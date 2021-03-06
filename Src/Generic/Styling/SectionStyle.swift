//
//  SectionStyle.swift
//  Hedvig
//
//  Created by Sam Pettersson on 2019-01-05.
//  Copyright © 2019 Hedvig AB. All rights reserved.
//

import Form
import Foundation

extension BorderStyle {
    static let standard = BorderStyle(
        width: 1 / UIScreen.main.scale,
        color: .grayBorder,
        cornerRadius: 0,
        borderEdges: [UIRectEdge.bottom, UIRectEdge.top]
    )

    static let standardRounded = BorderStyle(
        width: 0,
        color: .clear,
        cornerRadius: 5,
        borderEdges: [UIRectEdge.top, UIRectEdge.bottom, UIRectEdge.left, UIRectEdge.right]
    )
}

extension BackgroundStyle {
    static let white = BackgroundStyle(color: .white, border: .standard)
    static let turquoise = BackgroundStyle(color: .turquoise, border: .standard)
    static let whiteRoundedBorder = BackgroundStyle(color: .white, border: .standardRounded)

    static let purple = BackgroundStyle(
        color: UIColor.purple,
        border: .standard
    )

    static let purpleOpaque = BackgroundStyle(
        color: UIColor.purple.withAlphaComponent(0.2),
        border: .standard
    )

    static let purpleOpaqueRoundedBorder = BackgroundStyle(
        color: UIColor.purple.withAlphaComponent(0.2),
        border: .standardRounded
    )

    static let pink = BackgroundStyle(
        color: UIColor.pink.withAlphaComponent(0.2),
        border: .standard
    )

    static let pinkRoundedBorder = BackgroundStyle(
        color: UIColor.pink.withAlphaComponent(0.2),
        border: .standardRounded
    )

    static let invisible = BackgroundStyle(
        color: UIColor.clear,
        border: BorderStyle.none
    )
}

extension SeparatorStyle {
    static let darkGray = SeparatorStyle(width: 0.25, color: .grayBorder)
}

extension InsettedStyle where Style == SeparatorStyle {
    static let inset = InsettedStyle(
        style: .darkGray,
        insets: UIEdgeInsets(
            top: 0,
            left: SectionStyle.sectionPlainRowInsets.left,
            bottom: 0,
            right: 0
        )
    )

    static let insetLargeIcons = InsettedStyle(
        style: .darkGray,
        insets: UIEdgeInsets(
            top: 0,
            left: SectionStyle.sectionPlainRowInsets.left + 60,
            bottom: 0,
            right: 0
        )
    )
}

extension SectionBackgroundStyle {
    static let white = SectionBackgroundStyle(
        background: .white,
        topSeparator: .inset,
        bottomSeparator: .inset
    )

    static let whiteLargeIcons = SectionBackgroundStyle(
        background: .white,
        topSeparator: .insetLargeIcons,
        bottomSeparator: .insetLargeIcons
    )

    static let whiteRoundedBorder = SectionBackgroundStyle(
        background: .whiteRoundedBorder,
        topSeparator: .inset,
        bottomSeparator: .inset
    )

    static let purple = SectionBackgroundStyle(
        background: .purple,
        topSeparator: .inset,
        bottomSeparator: .inset
    )

    static let purpleOpaque = SectionBackgroundStyle(
        background: .purpleOpaque,
        topSeparator: .inset,
        bottomSeparator: .inset
    )

    static let purpleOpaqueLargeIcons = SectionBackgroundStyle(
        background: .purpleOpaque,
        topSeparator: .insetLargeIcons,
        bottomSeparator: .insetLargeIcons
    )

    static let purpleOpaqueRoundedBorder = SectionBackgroundStyle(
        background: .purpleOpaqueRoundedBorder,
        topSeparator: .inset,
        bottomSeparator: .inset
    )

    static let pink = SectionBackgroundStyle(
        background: .pink,
        topSeparator: .inset,
        bottomSeparator: .inset
    )

    static let pinkRoundedBorder = SectionBackgroundStyle(
        background: .pinkRoundedBorder,
        topSeparator: .inset,
        bottomSeparator: .inset
    )

    static let invisible = SectionBackgroundStyle(
        background: .invisible,
        topSeparator: .none,
        bottomSeparator: .none
    )
}

extension SectionStyle.Background {
    static let standard = SectionStyle.Background(style: .white)
    static let highlighted = SectionStyle.Background(style: .purple)
    static let standardLargeIcons = SectionStyle.Background(style: .whiteLargeIcons)
    static let standardRoundedBorder = SectionStyle.Background(style: .whiteRoundedBorder)
    static let selected = SectionStyle.Background(style: .purpleOpaque)
    static let selectedLargeIcons = SectionStyle.Background(style: .purpleOpaqueLargeIcons)
    static let selectedRoundedBorder = SectionStyle.Background(style: .purpleOpaqueRoundedBorder)
    static let selectedDanger = SectionStyle.Background(style: .pink)
    static let selectedDangerRoundedBorder = SectionStyle.Background(style: .pinkRoundedBorder)
    static let invisible = SectionStyle.Background(style: .invisible)
}

extension HeaderFooterStyle {
    static let standard = HeaderFooterStyle(
        text: .sectionHeader,
        backgroundImage: nil,
        insets: UIEdgeInsets(
            top: 15,
            left: 20,
            bottom: 10,
            right: 20
        ),
        emptyHeight: 0
    )
}

extension SectionStyle {
    static let sectionPlainRowInsets = UIEdgeInsets(
        top: 15,
        left: 20,
        bottom: 15,
        right: 20
    )

    static let sectionPlainItemSpacing: CGFloat = 10
    static let sectionPlainMinRowHeight: CGFloat = 0

    static let sectionPlain = SectionStyle(
        rowInsets: SectionStyle.sectionPlainRowInsets,
        itemSpacing: SectionStyle.sectionPlainItemSpacing,
        minRowHeight: SectionStyle.sectionPlainMinRowHeight,
        background: .standard,
        selectedBackground: .selected,
        header: .standard,
        footer: .standard
    )

    static let sectionPlainLargeIcons = SectionStyle(
        rowInsets: SectionStyle.sectionPlainRowInsets,
        itemSpacing: SectionStyle.sectionPlainItemSpacing,
        minRowHeight: SectionStyle.sectionPlainMinRowHeight,
        background: .standardLargeIcons,
        selectedBackground: .selectedLargeIcons,
        header: .standard,
        footer: .standard
    )
}

extension DynamicSectionStyle {
    static let sectionPlain = DynamicSectionStyle { _ -> SectionStyle in
        .sectionPlain
    }

    static let sectionPlainLargeIcons = DynamicSectionStyle { _ -> SectionStyle in
        .sectionPlainLargeIcons
    }
}
