//
//  MainViewModel.swift
//  Quizzler
//
//  Created by Ömer Faruk Okumuş on 3.04.2023.
//

import Foundation

class MainViewModel {
    private lazy var quiz = Quiz()
    private var quizTimer: QuizTimer? = nil
    private var mCurrentQuestion = 0
    
    private var mScore = 0
    var score: Int { mScore }
    
    private var mCurrentQuestionText = ObservableObject<String?>(value: nil)
    var currentQuestionText: ObservableObject<String?> { mCurrentQuestionText }
    
    private var mIsTimerUp = ObservableObject(value: false)
    var isTimerUp: ObservableObject<Bool> { mIsTimerUp }
    
    private var mIsQuizFinished = false
    var isQuizFinished: Bool { mIsQuizFinished }
    
    private var mIsLastQuestionOn = false
    var isLastQuestionOn: Bool { mIsLastQuestionOn }
    
    private var mIsAnswerTrue = ObservableObject(value: false)
    var isAnswerTrue: ObservableObject<Bool> { mIsAnswerTrue }
    
    var questionCount: Int { quiz.questionCount }
    
    var firstQuestion: String { quiz.firstQuestion }
    
    init() {
        mCurrentQuestionText.setValue(value: firstQuestion)
    }
    
    func setIsAnswerCorrect(_ answer: String) {
        mIsAnswerTrue.setValue(value: quiz.isAnswerTrue(answer, mCurrentQuestion))
    }
    
    func increaseScore() {
        mScore += 1
    }
    
    func resetQuiz() {
        mScore = 0
        mCurrentQuestion = 0
    }
    
    func startTimer(forSeconds: Int) {
        quizTimer = QuizTimer(totalSeconds: forSeconds) { [self] in
            mIsTimerUp.setValue(value: true)
            mIsTimerUp.setValue(value: false, doNotNotify: true)
        }
        quizTimer?.startTimer()
    }
    
    func nextQuestion() {
        mCurrentQuestion += 1
        mCurrentQuestionText.setValue(value: quiz.getQuestion(mCurrentQuestion))
    }
    
    deinit {
        quizTimer?.invalidate()
    }
}
