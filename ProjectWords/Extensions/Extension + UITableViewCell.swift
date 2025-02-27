//
//  Extension + UITableViewCell.swift
//  ProjectWords
//
//  Created by Дарина Самохина on 06.08.2024.
//

import UIKit

extension UITableViewCell {
    func configure(with wordGroup: WordGroup) {
        let currentWords = wordGroup.words.filter("isLearned = false")
        var content = defaultContentConfiguration()
        
        content.text = wordGroup.name
        
        if wordGroup.words.isEmpty {
            content.secondaryText = "0"
            accessoryType = .none
        } else if currentWords.isEmpty {
            content.secondaryText = nil
            accessoryType = .checkmark
        } else {
            content.secondaryText = currentWords.count.formatted()
            accessoryType = .none
        }

        contentConfiguration = content
    }
}
