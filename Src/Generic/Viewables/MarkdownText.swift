//
//  MarkdownText.swift
//  ugglan
//
//  Created by Gustaf Gunér on 2019-04-04.
//

import Foundation
import Flow
import Form
import UIKit
import MarkdownKit

struct MarkdownText {
    let text: String
    let style: TextStyle
}

extension MarkdownText: Viewable {
    func materialize(events: ViewableEvents) -> (UIView, Disposable) {
        let view = UIView()
        
        let bag = DisposeBag()
    
        let markdownParser = MarkdownParser(font: style.font, color: style.color)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = style.lineSpacing
        
        let attributedString = markdownParser.parse(text)
        
        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttributedString.length - 1))
        
        let markdownText = UILabel()
        markdownText.numberOfLines = 0
        markdownText.lineBreakMode = .byWordWrapping
        markdownText.baselineAdjustment = .none
        markdownText.attributedText = mutableAttributedString
        
        bag += markdownText.didLayoutSignal.onValue { _ in
            markdownText.snp.remakeConstraints { make in
                make.width.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
        
        view.addSubview(markdownText)
        
        bag += view.didLayoutSignal.onValue { _ in
            view.snp.remakeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
        
        return (view, bag)
    }
}