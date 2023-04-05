//
//  ViewController.swift
//  Quizzler
//
//  Created by Ömer Faruk Okumuş on 6.01.2023.
//

import UIKit

class MainViewController: UIViewController {
        
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
        viewModel.isAnswerTrue.observe(observer: self) { [self] isAnswerTrue in
            if isAnswerTrue {
                viewModel.increaseScore()
                greenify(clickedButton)
            } else {
                greenify(getOtherButton())
                redify(clickedButton)
            }
            viewModel.startTimer(forSeconds: 1)
            
        }
        
        viewModel.isTimerUp.observe(observer: self) { [self] isTimerUp in
            if isTimerUp {
                clearButtonColors()
                unfreezeButtons()
                viewModel.nextQuestion()
                incrementProgressBar()
            }
        }
        
        viewModel.currentQuestionText.observe(observer: self) { [self] currentQuestionText in
            if currentQuestionText != nil {
                questionTextLabel.text = currentQuestionText
            } else {
                finishQuiz()                
            }
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

