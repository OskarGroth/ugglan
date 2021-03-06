//
//  BulletPointTable.swift
//  project
//
//  Created by Sam Pettersson on 2019-04-17.
//

import Flow
import Form
import Foundation
import UIKit

struct BulletPointTable {
    let bulletPoints: [CommonClaimsQuery.Data.CommonClaim.Layout.AsTitleAndBulletPoints.BulletPoint]
}

extension BulletPointTable: Viewable {
    func materialize(events _: ViewableEvents) -> (UITableView, Disposable) {
        let bag = DisposeBag()

        let sectionStyle = SectionStyle(
            rowInsets: UIEdgeInsets(
                top: 5,
                left: 20,
                bottom: 5,
                right: 20
            ),
            itemSpacing: 0,
            minRowHeight: 10,
            background: .invisible,
            selectedBackground: .invisible,
            header: .none,
            footer: .none
        )

        let dynamicSectionStyle = DynamicSectionStyle { _ in
            sectionStyle
        }

        let style = DynamicTableViewFormStyle(section: dynamicSectionStyle, form: .default)

        let tableKit = TableKit<EmptySection, BulletPointCard>(style: style, bag: bag)
        tableKit.view.isScrollEnabled = false

        let rows = bulletPoints.map {
            BulletPointCard(
                title: $0.title,
                icon: RemoteVectorIcon($0.icon.pdfUrl),
                description: $0.description
            )
        }

        bag += tableKit.delegate.willDisplayCell.onValue { cell, indexPath in
            cell.layer.zPosition = CGFloat(indexPath.row)
        }

        tableKit.set(Table(rows: rows), rowIdentifier: { $0.title })
        tableKit.view.backgroundColor = .offWhite

        return (tableKit.view, bag)
    }
}
