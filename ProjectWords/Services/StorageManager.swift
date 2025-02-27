//
//  StorageManager.swift
//  ProjectWords
//
//  Created by Дарина Самохина on 06.08.2024.
//

import Foundation
import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    let realm = try! Realm()
    
    private init() {}
    
    // MARK: - WordGroup
    //Save for TempData in DataManager
    func save(_ wordGroups: [WordGroup]) {
        write {
            realm.add(wordGroups)
        }
    }
    
    func save(_ wordGroup: String, completion: (WordGroup) -> Void) {
        write {
            let wordGroup = WordGroup(value: [wordGroup])
            realm.add(wordGroup)
            completion(wordGroup)
        }
    }
    
    func delete(_ wordGroup: WordGroup) {
        write {
            realm.delete(wordGroup.words)
            realm.delete(wordGroup)
        }
    }

    func edit(_ wordGroup: WordGroup, newValue: String) {
        write {
            wordGroup.name = newValue
        }
    }

    func done(_ wordGroup: WordGroup) {
        write {
            wordGroup.words.setValue(true, forKey: "isLearned")
        }
    }

    // MARK: - Word
    func save(_ text: String, transcription: String, and translation: String, to wordGroup: WordGroup, completion: (Word) -> Void) {
        write {
            let word = Word(value: [text, transcription, translation])
            wordGroup.words.append(word)
            completion(word)
        }
    }
    
    func delete(_ word: Word) {
        write {
            realm.delete(word)
        }
    }
    
    func edit(_ word: Word, to text: String, transcription: String, and translation: String) {
        write {
            word.name = text
            word.transcription = transcription
            word.translation = translation
        }
    }
    
    func done(_ word: Word) {
        write {
            word.isLearned.toggle()
        }
    }
}

//MARK: - Private Methods
extension StorageManager {
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
