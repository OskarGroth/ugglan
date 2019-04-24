//
//  DraggableOverlayHeader.swift
//  ugglan
//
//  Created by Gustaf Gunér on 2019-04-24.
//

import Foundation
import Flow
import UIKit

struct DraggableOverlayHeader {
    let title: String
    let icon: ImageAsset?
    
    init(title: String, icon: ImageAsset? = nil) {
        self.title = title
        self.icon = icon
    }
}

extension DraggableOverlayHeader: Viewable {
    func materialize(events: ViewableEvents) -> (UIView, Disposable) {
        let view = UIView()
        
        let bag = DisposeBag()
        
        if (self.icon != nil) {
            let icon = Icon(icon: self.icon!, iconWidth: 60)
            view.addSubview(icon)
            
            icon.snp.makeConstraints { make in
                make.width.equalTo(60)
                make.height.equalTo(60)
                make.leading.equalToSuperview().inset(24)
                make.top.equalToSuperview().inset(24)
            }
        }
        
        let titleLabel = UILabel()
        titleLabel.style = .standaloneLargeTitle
        titleLabel.textAlignment = .left
        
        bag += titleLabel.setDynamicText(DynamicString(title))
        
        let titleContainer = UIView()
        titleContainer.addSubview(titleLabel)
        
        bag += titleLabel.didLayoutSignal.onValue { _ in
            titleLabel.snp.remakeConstraints { make in
                make.width.equalToSuperview().inset(24)
                make.height.equalTo(24)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(0)
            }
        }
        
        view.addSubview(titleContainer)
        
        titleContainer.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        return (view, bag)
    }
}
