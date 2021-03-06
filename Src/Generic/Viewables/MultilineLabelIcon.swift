//
//  CheckmarkLabel.swift
//  ugglan
//
//  Created by Axel Backlund on 2019-04-10.
//

import Flow
import Form
import Foundation
import UIKit

struct MultilineLabelIcon {
    let styledTextSignal: ReadWriteSignal<StyledText>
    let iconAsset: ImageAsset
    let iconWidth: CGFloat

    init(styledText: StyledText, icon: ImageAsset, iconWidth: CGFloat) {
        styledTextSignal = ReadWriteSignal(styledText)
        iconAsset = icon
        self.iconWidth = iconWidth
    }
}

extension MultilineLabelIcon: Viewable {
    func materialize(events _: ViewableEvents) -> (UIView, Disposable) {
        let bag = DisposeBag()

        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .leading

        view.spacing = 10

        let icon = Icon(
            icon: iconAsset,
            iconWidth: iconWidth
        )
        view.addArrangedSubview(icon)

        icon.snp.makeConstraints { make in
            make.width.equalTo(iconWidth)
            make.height.equalTo(iconWidth + 4)
        }

        let label = UILabel()

        bag += styledTextSignal.atOnce().map { styledText -> StyledText in
            styledText.restyled { (textStyle: inout TextStyle) in
                textStyle.numberOfLines = 0
                textStyle.lineBreakMode = .byWordWrapping
            }
        }.bindTo(label, \.styledText)

        view.addArrangedSubview(label)

        bag += label.didLayoutSignal.onValue {
            label.sizeToFit()
            label.preferredMaxLayoutWidth = label.frame.size.width
            label.snp.makeConstraints { make in
                make.height.equalTo(label.intrinsicContentSize.height)
            }
        }

        return (view, bag)
    }
}
