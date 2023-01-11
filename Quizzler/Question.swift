//
//  Question.swift
//  Quizzler
//
//  Created by Ömer Faruk Okumuş on 11.01.2023.
//

import Foundation

struct Question {
    let q: String
    let a: String
    
    func isAnswerTrue(_ answer: String?) -> Bool {
        return a == answer
    }
}
