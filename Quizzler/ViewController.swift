//
//  ViewController.swift
//  Quizzler
//
//  Created by Ömer Faruk Okumuş on 6.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    
    private let quiz: Quiz = Quiz.getQuizInstance()
    private var chunk: Float = 0
    private var timer: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initScoreText()
        initQuestionText()
        initChunk()
        initProgressBar()
    }
    
    private func initScoreText() {
        scoreLabel.text = "0"
    }
    
    private func initQuestionText() {
        questionTextLabel.text = quiz.getFirstQuestion()
    }
    
    private func initChunk() {
        chunk = 1.0 / Float(quiz.getQuestionCount())
    }
    
    private func initProgressBar() {
        resetProgressBar()
        progressBar.progress += chunk
    }
    
    private func resetProgressBar() {
        progressBar.progress = 0
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        freezeButtons()
        let button = getButton(sender)
        let otherButton = getOtherButton(sender)
        if !quiz.isQuizFinished() || quiz.isLastQuestionOn() {
            checkAndEncolorButtons(button, otherButton)
            setTimer()
        }
    }
    
    private func checkAndEncolorButtons(_ button: UIButton,
                                        _ otherButton: UIButton) {
        if quiz.isAnswerTrue(button.currentTitle) {
            updateScore()
            greenify(button)
        } else {
            redify(button)
            greenify(otherButton)
        }
    }
    
    private func getButton(_ button: UIButton) -> UIButton {
        switch button {
            case trueButton: return trueButton
            case falseButton: return falseButton
            default: return falseButton
        }
    }
    
    private func getOtherButton(_ button: UIButton) -> UIButton {
        switch button {
            case trueButton: return falseButton
            case falseButton: return trueButton
            default: return falseButton
        }
    }

    
    private func updateScore() {
        quiz.increaseScore()
        scoreLabel.text = "Score: \(quiz.getScore())"
    }
    
    private func encolorButtons(buttonToBeGreen: UIButton) {
        switch buttonToBeGreen {
            case trueButton:
                greenify(trueButton)
                redify(falseButton)
            case falseButton:
                greenify(falseButton)
                redify(trueButton)
            default: break
        }
    }
    
    private func greenify(_ button: UIButton) {
        button.backgroundColor = .green
    }
    
    private func redify(_ button: UIButton) {
        button.backgroundColor = .red
    }
    
    private func setTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    @objc func updateUI() {
        if quiz.isLastQuestionOn() {
            finishQuiz()
        } else {
        clearButtonColors()
        getNextQuestion()
        incrementProgressBar()
        unfreezeButtons()
        }
    }
    
    private func finishQuiz() {
        questionTextLabel.text = "Quiz is finished. Your score is \(quiz.getScore())/\(quiz.getQuestionCount())"
        freezeButtons()
        hideButtons()
    }
    
    private func hideButtons() {
        trueButton.alpha = 0.0
        falseButton.alpha = 0.0
    }
    
    private func clearButtonColors() {
        trueButton.backgroundColor = .clear
        falseButton.backgroundColor = .clear
    }
    
    private func getNextQuestion() {
        questionTextLabel.text = quiz.getNextQuestion()
    }
    
    private func incrementProgressBar() {
        progressBar.progress += chunk
    }
    
    
    private func freezeButtons() {
        trueButton.isUserInteractionEnabled = false
        falseButton.isUserInteractionEnabled = false
    }
    
    
    private func unfreezeButtons() {
        trueButton.isUserInteractionEnabled = true
        falseButton.isUserInteractionEnabled = true
    }
    
}

