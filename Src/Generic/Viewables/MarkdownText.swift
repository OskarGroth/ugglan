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
    let intrinsicContentSizeSignal: ReadSignal<CGSize>
    
    private let intrinsicContentSizeReadWriteSignal = ReadWriteSignal<CGSize>(
        CGSize(width: 0, height: 0)
    )
    
    init(text: String, style: TextStyle) {
        self.text = text
        self.style = style
        intrinsicContentSizeSignal = intrinsicContentSizeReadWriteSignal.readOnly()
    }
    
}

extension MarkdownText: Viewable {
    func materialize(events: ViewableEvents) -> (UILabel, Disposable) {
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
            
            self.intrinsicContentSizeReadWriteSignal.value = markdownText.intrinsicContentSize
        }
        
        return (markdownText, bag)
    }
}
