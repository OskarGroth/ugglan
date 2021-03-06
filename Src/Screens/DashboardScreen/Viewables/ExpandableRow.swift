//
//  ExpandableRow.swift
//  ugglan
//
//  Created by Axel Backlund on 2019-03-29.
//

import Flow
import Form
import Foundation
import UIKit

struct ExpandableRow<Content: Viewable, ExpandableContent: Viewable> where
    Content.Matter == UIView,
    Content.Events == ViewableEvents,
    Content.Result == Disposable,
    ExpandableContent.Matter == UIView,
    ExpandableContent.Events == ViewableEvents,
    ExpandableContent.Result == Disposable {
    let content: Content
    let expandedContent: ExpandableContent
    let isOpenSignal: ReadWriteSignal<Bool>
    let transparent: Bool

    init(
        content: Content,
        expandedContent: ExpandableContent,
        isOpen: Bool = false,
        transparent: Bool = false
    ) {
        self.content = content
        self.expandedContent = expandedContent
        isOpenSignal = ReadWriteSignal<Bool>(isOpen)
        self.transparent = transparent
    }
}

extension ExpandableRow: Viewable {
    func materialize(events _: ViewableEvents) -> (UIView, Disposable) {
        let bag = DisposeBag()

        let containerView = UIView()

        if !transparent {
            containerView.backgroundColor = .white
            containerView.layer.cornerRadius = 15
            containerView.layer.shadowOpacity = 0.15
            containerView.layer.shadowOffset = CGSize(width: 0, height: 6)
            containerView.layer.shadowRadius = 8
            containerView.layer.shadowColor = UIColor.darkGray.cgColor
        } else {
            containerView.backgroundColor = .transparent
        }

        let clippingView = UIView()
        clippingView.clipsToBounds = true

        let expandableStackView = UIStackView()
        expandableStackView.axis = .vertical

        bag += expandableStackView.addArranged(content)

        let divider = Divider(backgroundColor: .offWhite)
        bag += expandableStackView.addArranged(divider) { dividerView in
            dividerView.alpha = isOpenSignal.value ? 1 : 0

            bag += isOpenSignal
                .atOnce()
                .map { $0 ? 0 : 0.15 }
                .flatMapLatest { Signal(after: $0) }
                .flatMapLatest { self.isOpenSignal.atOnce().plain() }
                .map { $0 ? 1 : 0 }
                .animated(style: AnimationStyle.easeOut(duration: 0.2), animations: { opacity in
                    dividerView.alpha = opacity
                })
        }

        bag += expandableStackView.addArranged(expandedContent) { expandedView in
            expandedView.isHidden = !isOpenSignal.value
            expandedView.alpha = isOpenSignal.value ? 1 : 0

            bag += isOpenSignal
                .atOnce()
                .map { !$0 }
                .animated(style: SpringAnimationStyle.lightBounce()) { isHidden in
                    expandedView.isHidden = isHidden
                }

            bag += isOpenSignal
                .atOnce()
                .map { $0 ? 0.05 : 0 }
                .flatMapLatest { Signal(after: $0) }
                .flatMapLatest { self.isOpenSignal.atOnce().plain() }
                .map { $0 ? 1 : 0 }
                .animated(style: .easeOut(duration: 0.25), animations: { opacity in
                    expandedView.alpha = opacity
                })
        }

        clippingView.addSubview(expandableStackView)
        containerView.addSubview(clippingView)

        expandableStackView.snp.makeConstraints { make in
            make.width.height.centerX.centerY.equalToSuperview()
        }

        clippingView.snp.makeConstraints { make in
            make.width.height.centerX.centerY.equalToSuperview()
        }

        let tapGesture = UITapGestureRecognizer()
        bag += containerView.install(tapGesture)

        bag += tapGesture
            .signal(forState: .ended)
            .withLatestFrom(isOpenSignal.atOnce().plain())
            .map { $0.1 }
            .map { !$0 }
            .bindTo(isOpenSignal)

        return (containerView, bag)
    }
}
