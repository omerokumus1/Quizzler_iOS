//
//  Quiz.swift
//  Quizzler
//
//  Created by Ömer Faruk Okumuş on 11.01.2023.
//

import Foundation

class Quiz {
    private var questions = [
        Question(q: "A slug's blood is green.", a: "True"),
        Question(q: "Approximately one quarter of human bones are in the feet.", a: "True"),
        Question(q: "The total surface area of two human lungs is approximately 70 square metres.", a: "True"),
        Question(q: "In West Virginia, USA, if you accidentally hit an animal with your car, you are free to take it home to eat.", a: "True"),
       /* Question(q: "In London, UK, if you happen to die in the House of Parliament, you are technically entitled to a state funeral, because the building is considered too sacred a place.", a: "False"),
        Question(q: "It is illegal to pee in the Ocean in Portugal.", a: "True"),
        Question(q: "You can lead a cow down stairs but not up stairs.", a: "False"),
        Question(q: "Google was originally called 'Backrub'.", a: "True"),
        Question(q: "Buzz Aldrin's mother's maiden name was 'Moon'.", a: "True"),
        Question(q: "The loudest sound produced by any animal is 188 decibels. That animal is the African Elephant.", a: "False"),
        Question(q: "No piece of square dry paper can be folded in half more than 7 times.", a: "False"),
        Question(q: "Chocolate affects a dog's heart and nervous system; a few ounces are enough to kill a small dog.", a: "True")
        */
    ]
    
    private var currentQuestion = 0
    private var score: Int = 0
    
    // Singleton
    private static var quiz: Quiz? = nil
    
    // Singleton
    private init() {}
    
    // Singleton
    static func getQuizInstance() -> Quiz {
        if quiz == nil {
            quiz = Quiz()
            quiz?.questions.shuffle()
            return quiz!
        } else {
            return quiz!
        }
    }
    
    func getNextQuestion() -> String {
        currentQuestion += 1
        let question = questions[currentQuestion]
        return question.q
    }
    
    func getQuestionCount() -> Int {
        return questions.count
    }
    
    func isAnswerTrue(_ answer: String?) -> Bool {
        return questions[self.currentQuestion].isAnswerTrue(answer)
    }
    
    func isQuizFinished() -> Bool {
        return currentQuestion > (getQuestionCount() - 1)
    }
    
    func isLastQuestionOn() -> Bool {
        return currentQuestion == (getQuestionCount() - 1)
    }
    
    func getFirstQuestion() -> String {
        return (questions.first?.q)!
    }
    
    func getLastQuestion() -> String {
        return (questions.last?.q)!
    }
    
    func getScore() -> Int {
        return score
    }
    
    func increaseScore() {
        score += 1
    }
    
    
    func resetQuiz() {
        self.questions.shuffle()
        self.currentQuestion = 0
        self.score = 0
    }
}
