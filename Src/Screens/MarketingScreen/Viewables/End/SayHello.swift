//
//  SayHello.swift
//  Hedvig
//
//  Created by Sam Pettersson on 2018-12-17.
//  Copyright © 2018 Hedvig AB. All rights reserved.
//

import Flow
import Foundation
import UIKit

struct SayHello: Viewable {
    func materialize(events: ViewableEvents) -> (UIView, Disposable) {
        let label = UILabel(value: "Säg hej till Hedvig", style: .body)
        label.alpha = 0

        let bag = DisposeBag()

        bag += events.wasAdded.delay(by: 0.3).animated(style: AnimationStyle.easeOut(duration: 0.25)) {
            label.alpha = 1
        }

        return (label, bag)
    }
}
