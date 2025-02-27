//
//  WordGroupsViewController.swift
//  ProjectWords
//
//  Created by Дарина Самохина on 13.08.2024.
//

import UIKit
import RealmSwift

class WordGroupsViewController: UIViewController {
    
    @IBOutlet var groupTableView: UITableView!
    
    var wordGroups: Results<WordGroup>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordGroups = StorageManager.shared.realm.objects(WordGroup.self)
        setupNavigationBar()
        createTempData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groupTableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = groupTableView.indexPathForSelectedRow else { return }
        guard let wordsVC = segue.destination as? WordsViewController else { return }
        let wordGroup = wordGroups[indexPath.row]
        wordsVC.wordGroup = wordGroup
    }
    
    //MARK: - Actions
    @IBAction func sortingGroup(_ sender: UISegmentedControl) {
        wordGroups = sender.selectedSegmentIndex == 0
            ? wordGroups.sorted(byKeyPath: "date")
            : wordGroups.sorted(byKeyPath: "name")
        groupTableView.reloadData()
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }
}
//MARK: - UI
extension WordGroupsViewController {
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButtonItem
        navigationController?.navigationBar.tintColor = .systemOrange.withAlphaComponent(0.6)
    }
    
    private func createTempData() {
        if !UserDefaults.standard.bool(forKey: "done") {
            DataManager.shared.createTempData { [weak self] in
                UserDefaults.standard.setValue(true, forKey: "done")
                self?.groupTableView.reloadData()
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension WordGroupsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        wordGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath)
        let wordGroup = wordGroups[indexPath.row]
        cell.configure(with: wordGroup)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension WordGroupsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskList = wordGroups[indexPath.row]
        let deleteAction = deleteAction(for: taskList, in: tableView, at: indexPath)
        let editAction = editAction(for: taskList, in: tableView, at: indexPath)
        let doneAction = doneAction(for: taskList, in: tableView, at: indexPath)
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
}

//MARK: - UIContextualAction
extension WordGroupsViewController {
    private func deleteAction(for taskList: WordGroup, in tableView: UITableView, at indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style:.destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(taskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return deleteAction
    }

    private func editAction(for taskList: WordGroup, in tableView: UITableView, at indexPath: IndexPath) -> UIContextualAction {
        let editAction = UIContextualAction(style:.normal, title: "Edit") { [weak self] _, _, isDone in
            self?.showAlert(with: taskList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        editAction.backgroundColor = .orange
        return editAction
    }

    private func doneAction(for taskList: WordGroup, in tableView: UITableView, at indexPath: IndexPath) -> UIContextualAction {
        let doneAction = UIContextualAction(style:.normal, title: "Done") { _, _, isDone in
            StorageManager.shared.done(taskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return doneAction
    }
}
    
//MARK: - Alert
extension WordGroupsViewController {
    private func showAlert(with wordGroup: WordGroup? = nil, completion: (() -> Void)? = nil) {
        let title = wordGroup != nil ? "Edit Group" : "New Group"
        let alert = UIAlertController.createAlert(
            withTitle: title,
            andMessage: "Please set title for new word group"
        )
        
        alert.action(with: wordGroup) { [weak self] newValue in
            if let wordGroup = wordGroup, let completion = completion {
                StorageManager.shared.edit(wordGroup, newValue: newValue)
                completion()
            } else {
                self?.save(wordGroup: newValue)
            }
        }
        present(alert, animated: true)
    }
    
    private func save(wordGroup: String) {
        StorageManager.shared.save(wordGroup) { wordGroup in
            let rowIndex = IndexPath(row: wordGroups.index(of: wordGroup) ?? 0, section: 0)
            groupTableView.insertRows(at: [rowIndex], with: .automatic)
        }
    }
}
