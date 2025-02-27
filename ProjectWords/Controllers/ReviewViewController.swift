//
//  ReviewViewController.swift
//  ProjectWords
//
//  Created by Дарина Самохина on 06.08.2024.
//

import UIKit
import RealmSwift

class ReviewViewController: UIViewController {
    
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var cardView: UIView! {
        didSet {
            cardView.layer.borderWidth = 3
            cardView.layer.cornerRadius = 15
        }
    }
    
    var wordGroup: WordGroup!
    
    private var words: Results<Word>!
    private var colorsOfCard: (backgroundColor: UIColor, borderColor: UIColor)?
    private var randomIndex = 0
    private var cardIsFlipped = false {
        didSet {
            displayCardWithWord()
        }
    }
    private var numberOfCurrentCard = 1 {
        didSet {
            displayCardCounter()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        words = wordGroup.words.filter("isLearned = false")
        setupUI()
    }
    
    //MARK: - Actions
    @IBAction func flipButtonDidPressed(_ sender: UIButton) {
        UIView.transition(
            with: cardView,
            duration: 0.5,
            options: [.transitionFlipFromTop],
            animations: {
                self.displayCardWithWord()
            }
        )
        cardIsFlipped.toggle()
        sender.tapping()
    }

    @IBAction func nextButtonDidPressed(_ sender: UIButton) {
        getRandomWordIndex()
        UIView.animate(withDuration: 0.5) {
            self.wordLabel.alpha = 0
            self.cardView.alpha = 0
        } completion: { _ in
            self.getColorsToCard()
            self.cardIsFlipped = false
            self.makeCardVisible()
        }
        doCardCounting()
        sender.tapping()
    }
}


//MARK: - UI
extension ReviewViewController {
    private func setupUI() {
        nextButton.isEnabled = numberOfCurrentCard == 1 ? true : false
        title = "Words Review"
        navigationController?.navigationBar.tintColor = .systemOrange.withAlphaComponent(0.6)
        displayCardCounter()
        getColorsToCard()
        getRandomWordIndex()
        cardIsFlipped = false
    }
    
    private func getRandomWordIndex() {
        randomIndex = Int.random(in: 0..<words.count)
    }
    
    private func displayCardCounter() {
        counterLabel.text = "\(numberOfCurrentCard)/\(words.count)"
    }
    
    private func doCardCounting() {
        numberOfCurrentCard = (numberOfCurrentCard % words.count) + 1
    }
    
    private func makeCardVisible() {
        UIView.animate(withDuration: 0.5) {
            self.wordLabel.alpha = 1
            self.cardView.alpha = 1
        }
    }

    private func getColorsToCard() {
        let red = Double.random(in: 120..<255)/255
        let green = Double.random(in: 120..<255)/255
        let blue = Double.random(in: 120..<255)/255
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        let cardColor = color.withAlphaComponent(0.4)
        let borderColor = color.withAlphaComponent(0.6)
        colorsOfCard = (cardColor, borderColor)
    }

    private func displayCardWithWord() {
        if !cardIsFlipped {
            cardView.backgroundColor = .white
            cardView.layer.borderColor = colorsOfCard?.borderColor.cgColor
            wordLabel.text = words[randomIndex].name
        } else {
            cardView.backgroundColor = colorsOfCard?.backgroundColor
            cardView.layer.borderColor = colorsOfCard?.borderColor.cgColor
            let transcription = words[randomIndex].transcription
            let translation = words[randomIndex].translation
            wordLabel.text = !transcription.isEmpty
                ? "\(transcription)\n\(translation)"
                : "\(translation)"
        }
    }
}
