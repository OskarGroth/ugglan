//
//  DraggableOverlayText.swift
//  ugglan
//
//  Created by Gustaf Gunér on 2019-04-24.
//

import Foundation
import Flow
import UIKit

struct DraggableOverlayText {
    let text: String
    let intrinsicContentSizeSignal = ReadWriteSignal<CGSize>(
        CGSize(width: 0, height: 0)
    )
}

extension DraggableOverlayText: Viewable {
    func materialize(events: ViewableEvents) -> (UIView, Disposable) {
        let view = UIView()
        
        let bag = DisposeBag()
        
        let body = MarkdownText(text: text, style: .bodyOffBlack)
        
        bag += view.add(body)
        
        bag += body.intrinsicContentSizeSignal.onValue { bodySize in
            self.intrinsicContentSizeSignal.value = bodySize
        }
        
        bag += view.didLayoutSignal.onValue { _ in
            view.snp.remakeConstraints { make in
                make.width.equalToSuperview().inset(24)
                make.height.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
        
        return (view, bag)
    }
}
