//
//  DraggableOverlayContent.swift
//  Ugglan
//
//  Created by Gustaf Gunér on 2019-04-24.
//

import Apollo
import Flow
import Form
import Presentation
import UIKit

struct DraggableOverlayContent {
    let canScrollSignal = ReadWriteSignal<Bool>(false)
    let title: String
    let icon: ImageAsset?
    let body: String
    
    init(title: String, icon: ImageAsset? = nil, body: String) {
        self.title = title
        self.icon = icon
        self.body = body
    }
}

extension DraggableOverlayContent: Presentable {
    func materialize() -> (UIViewController, Disposable) {
        let bag = DisposeBag()
        
        let viewController = UIViewController()
        
        let containerView = UIView()
        
        let extraHeight = self.icon != nil ? 60 : 0
        
        let header = DraggableOverlayHeader(title: self.title, icon: self.icon)
        
        bag += containerView.add(header) { headerView in
            headerView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(64 + extraHeight)
                make.top.equalTo(0)
            }
        }
        
        let bodyView = UIScrollView()
        bodyView.showsVerticalScrollIndicator = false
        bodyView.isScrollEnabled = false
        bodyView.alwaysBounceVertical = false
        
        containerView.addSubview(bodyView)
        
        let body = DraggableOverlayText(text: self.body);
        
        bag += bodyView.add(body) { bodyText in
            bodyText.snp.makeConstraints { make in
                make.height.equalToSuperview()
            }
        }
        
        bag += body.intrinsicContentSizeSignal.onValue { bodySize in
            bodyView.contentSize = CGSize(
                width: bodySize.width,
                height: bodySize.height
            )
        }
        
        bodyView.snp.makeConstraints { make in
            make.top.equalTo(12 + 64 + extraHeight)
            make.width.equalToSuperview()
            make.height.equalToSuperview().offset(-12 - 64 - extraHeight)
        }
        
        bag += canScrollSignal.bindTo(bodyView, \.isScrollEnabled)
        
        viewController.view = containerView;
        
        return (viewController, bag)
    }
}

