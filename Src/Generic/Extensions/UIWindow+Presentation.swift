//
//  UIWindow+Presentation.swift
//  Hedvig
//
//  Created by Sam Pettersson on 2019-01-04.
//  Copyright © 2019 Hedvig AB. All rights reserved.
//

import Flow
import Foundation
import Presentation
import UIKit

extension UIWindow {
    /// Presents `presentable` on `self` and set `self`'s `rootViewController` to the
    /// presented view controller and make `self` key and visible.
    /// - Parameter options: Only `.embedInNavigationController` is supported, defaults to `[]`
    /// - Parameter animated: Performs a slide in animation of the new view controller by
    /// snapshotting current window if true
    func present<P: Presentable>(
        _ presentable: P,
        options: PresentationOptions = [],
        animated: Bool
    ) -> Disposable where
        P.Matter: UIViewController,
        P.Result == Disposable {
        let bag = DisposeBag()
        let (viewController, disposable) = presentable.materialize()
        bag += disposable

        if animated {
            let snapshot = snapshotView(afterScreenUpdates: true)!

            var subviews: [UIView] = []

            for view in viewController.view.subviews {
                subviews.append(view)
            }

            viewController.view.addSubview(snapshot)

            for view in subviews {
                view.transform = CGAffineTransform(
                    translationX: view.bounds.width,
                    y: 0
                )
                viewController.view.bringSubviewToFront(view)
            }

            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 5,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    for view in subviews {
                        view.transform = CGAffineTransform(
                            translationX: 0,
                            y: 0
                        )
                    }
                },
                completion: { _ in
                    snapshot.removeFromSuperview()
                }
            )
        }

        rootViewController = viewController.embededInNavigationController(options)

        makeKeyAndVisible()

        bag.hold(self)

        return bag
    }
}
