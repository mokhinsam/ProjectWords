//
//  WordsViewController.swift
//  ProjectWords
//
//  Created by Дарина Самохина on 06.08.2024.
//

import UIKit
import RealmSwift

class WordsViewController: UITableViewController {
    
    @IBOutlet var reviewButton: UIButton!
    
    var wordGroup: WordGroup!
    
    private var currentWords: Results<Word>!
    private var learnedWords: Results<Word>!

    override func viewDidLoad() {
        super.viewDidLoad()
        currentWords = wordGroup.words.filter("isLearned = false").sorted(byKeyPath: "name")
        learnedWords = wordGroup.words.filter("isLearned = true").sorted(byKeyPath: "name")
        setupNavigationBar()
        setupReviewButton()
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let reviewVC = segue.destination as? ReviewViewController else { return }
        reviewVC.wordGroup = wordGroup
    }

    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentWords.count : learnedWords.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "WORDS FOR LEARNING" : "LEARNED WORDS"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WordCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let word = indexPath.section == 0 ? currentWords[indexPath.row] : learnedWords[indexPath.row]
        content.text = "\(word.name) \(word.transcription)"
        content.secondaryText = word.translation
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let word = indexPath.section == 0
            ? currentWords[indexPath.row]
            : learnedWords[indexPath.row]
        let deleteAction = deleteAction(for: word, in: tableView, at: indexPath)
        let editAction = editAction(for: word, in: tableView, at: indexPath)
        let doneAction = doneAction(for: word, in: tableView, at: indexPath)
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
}

//MARK: - UIContextualAction
extension WordsViewController {
    private func deleteAction(for word: Word, in tableView: UITableView, at indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(word)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return deleteAction
    }

    private func editAction(for word: Word, in tableView: UITableView, at indexPath: IndexPath) -> UIContextualAction {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, isDone in
            self?.showAlert(with: word) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        editAction.backgroundColor = .orange
        return editAction
    }

    private func doneAction(for word: Word, in tableView: UITableView, at indexPath: IndexPath) -> UIContextualAction {
        let doneTitle = indexPath.section == 0 ? "Done" : "Undone"
        let doneAction = UIContextualAction(style: .normal, title: doneTitle) { [weak self] _, _, isDone in
            StorageManager.shared.done(word)
            let currentTaskIndex = IndexPath(
                row: self?.currentWords.index(of: word) ?? 0,
                section: 0
            )
            let completedTaskIndex = IndexPath(
                row: self?.learnedWords.index(of: word) ?? 0,
                section: 1
            )
            let destinationIndexRow = indexPath.section == 0 ? completedTaskIndex : currentTaskIndex
            tableView.moveRow(at: indexPath, to: destinationIndexRow)
            self?.setupReviewButton()
            isDone(true)
        }
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return doneAction
    }
}

//MARK: - Actions
extension WordsViewController {
    @objc private func addButtonPressed() {
        showAlert()
    }
}

//MARK: - UI
extension WordsViewController {
    private func setupNavigationBar() {
        title = wordGroup.name
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        navigationController?.navigationBar.tintColor = .systemOrange.withAlphaComponent(0.6)
    }
    
    private func setupReviewButton() {
        reviewButton.isEnabled = currentWords.count == 0 ? false : true
    }
}

//MARK: - Alert
extension WordsViewController {
    private func showAlert(with word: Word? = nil, completion: (() -> Void)? = nil) {
        let title = word != nil ? "Edit Word" : "New Word"
        let message = word != nil 
            ? "How do you want to edit the word?"
            : "What word do you want to learn?"
        
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: message)
        
        alert.action(with: word) { [weak self] name, transcription, translation in
            if let word = word, let completion = completion {
                StorageManager.shared.edit(
                    word,
                    to: name,
                    transcription: transcription,
                    and: translation
                )
                completion()
            } else {
                self?.save(name, transcription: transcription, and: translation)
                self?.setupReviewButton()
            }
        }
        
        present(alert, animated: true)
    }
    
    private func save(_ firstValue: String, transcription: String, and secondValue: String) {
        StorageManager.shared.save(
            firstValue, 
            transcription: transcription,
            and: secondValue,
            to: wordGroup
        ) { word in
            let rowIndex = IndexPath(row: currentWords.index(of: word) ?? 0, section: 0)
            tableView.insertRows(at: [rowIndex], with: .automatic)
        }
    }
}
