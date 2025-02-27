//
//  WordGroup.swift
//  ProjectWords
//
//  Created by Дарина Самохина on 06.08.2024.
//

import Foundation
import RealmSwift

class WordGroup: Object {
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var words = List<Word>()
}

class Word: Object {
    @Persisted var name = ""
    @Persisted var transcription = ""
    @Persisted var translation = ""
    @Persisted var isLearned = false
}
