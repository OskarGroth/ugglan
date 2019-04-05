//
//  CardNumberTextField.swift
//  UITests
//
//  Created by Sam Pettersson on 2019-04-05.
//

import Foundation
import Flow
import UIKit

struct CardNumberTextField {}

extension UITextField {
    
}

extension CardNumberTextField: Viewable {
    func materialize(events: ViewableEvents) -> (UIView, Disposable) {
        let bag = DisposeBag()
        let textField = UITextField()
        
        return (textField, bag)
    }
}
