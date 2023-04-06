//
//  MainViewModel.swift
//  Quizzler
//
//  Created by Ömer Faruk Okumuş on 3.04.2023.
//

import Foundation
import Combine

extension Notification.Name {
    static let currentQuestionText = Notification.Name(rawValue: "currentQuestionText")
    static let isTimerUp = Notification.Name(rawValue: "isTimerUp")
    static let isAnswerTrue = Notification.Name(rawValue: "isAnswerTrue")
}

class MainViewModel {
    private lazy var quiz = Quiz()
    private var quizTimer: QuizTimer? = nil
    private var currentQuestion = 0
    
    private(set) var score = 0
    
    private var currentQuestionText: String? = nil {
        didSet {
            if currentQuestionText == nil {
                NotificationCenter.default.post(name: .currentQuestionText, object: MainViewModel.self, userInfo: [:])
            } else {
                NotificationCenter.default.post(name: .currentQuestionText, object: MainViewModel.self,
                                                userInfo: [Notification.Name.currentQuestionText: currentQuestionText!])
            }
            
        }
    }
    
    private var isTimerUp = false {
        didSet {
            NotificationCenter.default.post(name: .isTimerUp, object: MainViewModel.self,
                                            userInfo: [Notification.Name.isTimerUp: isTimerUp])
        }
    }
    
    private var isAnswerTrue = false {
        didSet {
            NotificationCenter.default.post(name: .isAnswerTrue, object: MainViewModel.self,
                                            userInfo: [Notification.Name.isAnswerTrue: isAnswerTrue])
        }
    }
    
    private var isLastQuestionOn = false
    
    var questionCount: Int { quiz.questionCount }
    
    var firstQuestion: String { quiz.firstQuestion }
    
    init() {
        currentQuestionText = firstQuestion
        
    }
    
    func setIsAnswerCorrect(_ answer: String) {
        isAnswerTrue = quiz.isAnswerTrue(answer, currentQuestion)
    }
    
    func increaseScore() {
        score += 1
    }
    
    func resetQuiz() {
        score = 0
        currentQuestion = 0
    }
    
    func startTimer(forSeconds: Int) {
        quizTimer = QuizTimer(totalSeconds: forSeconds) { [self] in
            isTimerUp = true
            isTimerUp = false
        }
        quizTimer?.startTimer()
    }
    
    func nextQuestion() {
        currentQuestion += 1
        currentQuestionText = quiz.getQuestion(currentQuestion)
    }
    
    deinit {
        quizTimer?.invalidate()
    }
}
