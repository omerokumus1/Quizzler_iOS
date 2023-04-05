//
//  ObservableObject.swift
//  Quizzler
//
//  Created by Ömer Faruk Okumuş on 3.04.2023.
//

import Foundation
class ObservableObject<T> {
    private var value: T
    private var observer: Any?
    private var onValueChanged: ((T) -> Void)? = nil
    
    init(value: T) {
        self.value = value
    }
    
    func observe(observer: Any?, onValueChanged: ((T) -> Void)?) {
        self.observer = observer
        self.onValueChanged = onValueChanged
    }
    
    func setValue(value: T, doNotNotify: Bool = false) {
        self.value = value
        if !doNotNotify { onValueChanged?(value) }
    }
}
