//
//  CharityInformationBody.swift
//  ugglan
//
//  Created by Gustaf Gunér on 2019-04-04.
//

import Foundation
import Flow
import UIKit

struct CharityInformationBody {
    let text: String
}

extension CharityInformationBody: Viewable {
    func materialize(events: ViewableEvents) -> (UIView, Disposable) {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        
        let bag = DisposeBag()
        
        let body = MarkdownText(text: text, style: .bodyOffBlack)
        
        bag += view.add(body)
        
        bag += body.intrinsicContentSizeSignal.onValue { bodySize in
            view.contentSize = CGSize(
                width: bodySize.width,
                height: bodySize.height
            )
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
