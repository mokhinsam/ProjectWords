//
//  DataManager.swift
//  ProjectWords
//
//  Created by Дарина Самохина on 15.08.2024.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    func createTempData(completion: @escaping () -> Void) {
        let fruits = WordGroup()
        fruits.name = "Fruits (Chinese)"
        
        let apple = Word(value: ["苹果", "[píngguǒ]", "Apple", false])
        let orange = Word(value: ["橙子", "[chéngzi]", "Orange", true])
        let mango = Word(value: ["芒果", "[máng guŏ]", "Mango", true])
        let peach = Word(value: ["桃子", "[táo zi]", "Peach", false])
        let pear = Word(value: ["梨", "[lí]", "Pear", false])
        let persimmon = Word(value: ["柿子", "[shì zi]", "Persimmon", false])
        
        fruits.words.insert(
            contentsOf: [apple, orange, mango, peach, pear, persimmon],
            at: 0
        )

        let body = WordGroup()
        body.name = "Body (Russian)"
        
        let hair = Word(value: ["Hair", "[heə]", "Волосы", false])
        let eyelash = Word(
            value: [
                "Eyelash, eyelashes", 
                "[ˈaɪlæʃ], [ˈaɪlæʃiz]",
                "Ресница, ресницы",
                false
            ]
        )
        let nose = Word(value: ["Nose", "[nəʊz]", "Нос", true])
        let mouth = Word(value: ["Mouth", "[maʊθ]", "Рот", false])
        let lip = Word(value: ["Lip, lips", "", "Губа, губы", false])
        
        body.words.insert(
            contentsOf: [hair, eyelash, nose, mouth, lip],
            at: 0
        )
        
        DispatchQueue.main.async {
            StorageManager.shared.save([fruits, body])
            UserDefaults.standard.set(true, forKey: "done")
            completion()
        }
    }  
}

