//
//  ViewController.swift
//  Quizzler
//
//  Created by Ömer Faruk Okumuş on 6.01.2023.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var startAgainButton: UIButton!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    private let viewModel = MainViewModel()
    private var chunk = Float(0)
    private var clickedButton: UIButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideStartAgainButton()
        initScoreText()
        initQuestionText()
        initChunk()
        initProgressBar()
        observeViewModel()
    }
    
    
    
    private func observeViewModel() {
        // isAnswerTrue, isTimerUp, currentQuestionText
        NotificationCenter.default.addObserver(self, selector: #selector(observeIsAnswerTrue),
                                               name: .isAnswerTrue, object: MainViewModel.self)

        NotificationCenter.default.addObserver(self, selector: #selector(observeIsTimerUp),
                                               name: NSNotification.Name.isTimerUp, object: MainViewModel.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(observeCurrentQuestionText),
                                               name: NSNotification.Name.currentQuestionText, object: MainViewModel.self)

    }
    
    @objc private func observeIsAnswerTrue(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as? NSDictionary else { return }
        guard let isAnswerTrue = userInfo[Notification.Name.isAnswerTrue] as? Bool else { return }
        if  isAnswerTrue == true {
            viewModel.increaseScore()
            updateScoreLabel()
            greenify(clickedButton)
            viewModel.startTimer(forSeconds: 1)
        } else if isAnswerTrue == false {
            greenify(getOtherButton())
            redify(clickedButton)
            viewModel.startTimer(forSeconds: 1)
        }
    }
    
    @objc private func observeIsTimerUp(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as? NSDictionary else {return}
        guard let isTimerUp = userInfo[Notification.Name.isTimerUp] as? Bool else {return}
        if isTimerUp {
            clearButtonColors()
            unfreezeButtons()
            viewModel.nextQuestion()
            incrementProgressBar()
        }
    }
    
    @objc private func observeCurrentQuestionText(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo as? NSDictionary else {return}
        let currentQuestionText = userInfo[Notification.Name.currentQuestionText] as? String
        if currentQuestionText != nil {
            questionTextLabel.text = currentQuestionText
        } else {
            finishQuiz()
        }
    }
    
    private func hideStartAgainButton() {
        startAgainButton.isUserInteractionEnabled = false
        startAgainButton.alpha = 0
    }
    
    private func initScoreText() {
        scoreLabel.text = "Score: 0"
    }
    
    private func initQuestionText() {
        questionTextLabel.text = viewModel.firstQuestion
    }
    
    private func initChunk() {
        chunk = 1.0 / Float(viewModel.questionCount)
    }
    
    private func initProgressBar() {
        progressBar.progress = 0
        progressBar.progress += chunk
    }
    
    private func resetProgressBar() {
        initProgressBar()
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        freezeButtons()
        clickedButton = sender
        viewModel.setIsAnswerCorrect(sender.titleLabel!.text!)
    }
    
    
    @IBAction func startAgainButtonPressed(_ sender: UIButton) {
        hideStartAgainButton()
        resetScoreLabel()
        resetProgressBar()
        showTrueFalseButtons()
        unfreezeButtons()
        initQuestionText()
        viewModel.resetQuiz()
    }
    
    private func showTrueFalseButtons() {
        trueButton.alpha = 1.0
        falseButton.alpha = 1.0
    }
    
    private func resetScoreLabel() {
        initScoreText()
    }
    
    private func getOtherButton() -> UIButton {
        switch clickedButton {
            case trueButton: return falseButton
            case falseButton: return trueButton
            default: return falseButton
        }
    }
    
    
    private func updateScoreLabel() {
        scoreLabel.text = "Score: \(viewModel.score)"
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
    
    private func greenify(_ button: UIButton?) {
        button?.backgroundColor = .green
    }
    
    private func redify(_ button: UIButton?) {
        button?.backgroundColor = .red
    }
    
    
    private func finishQuiz() {
        questionTextLabel.text = "Quiz is finished. Your score is \(viewModel.score)/\(viewModel.questionCount)"
        freezeButtons()
        hideButtons()
        showStartAgainButton()
    }
    
    private func hideButtons() {
        trueButton.alpha = 0.0
        falseButton.alpha = 0.0
    }
    
    private func clearButtonColors() {
        trueButton.backgroundColor = .clear
        falseButton.backgroundColor = .clear
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
    
    private func showStartAgainButton() {
        startAgainButton.isUserInteractionEnabled = true
        startAgainButton.alpha = 1.0
    }
    
    
    
}

