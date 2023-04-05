//
//  QuizTimer.swift
//  Quizzler
//
//  Created by Ömer Faruk Okumuş on 3.04.2023.
//

import Foundation

class QuizTimer {
    private var timer: Timer? = nil
    private var onFinish: (() -> Void)? = nil
    private let totalSeconds: Int
    
    init(totalSeconds: Int, onFinish: (() -> Void)? = nil) {
        self.totalSeconds = totalSeconds
        self.onFinish = onFinish
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(totalSeconds), target: self,
                                     selector: #selector(timerFunction), userInfo: nil, repeats: false)
    }
    
    @objc private func timerFunction() {
        onFinish?()
    }
    
    func invalidate() {
        timer?.invalidate()
    }
}
