//
//  UIViewController+Viewable.swift
//  Hedvig
//
//  Created by Sam Pettersson on 2019-01-20.
//  Copyright © 2019 Hedvig AB. All rights reserved.
//

import Flow
import Foundation
import UIKit

extension UIViewController {
    func install<V: Viewable, View: UIView>(
        _ viewable: V
    ) -> Disposable where V.Matter == View, V.Result == Disposable, V.Events == ViewableEvents {
        let wasAddedCallbacker = Callbacker<Void>()
        let viewableEvents = ViewableEvents(
            wasAddedCallbacker: wasAddedCallbacker
        )
        let (matter, result) = viewable.materialize(events: viewableEvents)

        view = matter

        wasAddedCallbacker.callAll()

        return result
    }

    func install<V: Viewable, View: UIView, FutureResult: Any>(
        _ viewable: V
    ) -> Future<FutureResult> where V.Matter == View, V.Result == Future<FutureResult>, V.Events == ViewableEvents {
        let wasAddedCallbacker = Callbacker<Void>()
        let viewableEvents = ViewableEvents(
            wasAddedCallbacker: wasAddedCallbacker
        )
        let (matter, result) = viewable.materialize(events: viewableEvents)

        view = matter

        wasAddedCallbacker.callAll()

        return result
    }
}
