//
//  PaddedLabel.swift
//  MemoCloud
//
//  Created by Rizwan Shah on 05/12/2024.
//

import UIKit

@IBDesignable
class PaddedLabel: UILabel {

    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    @IBInspectable var paddingTop: CGFloat = 0
    @IBInspectable var paddingBottom: CGFloat = 0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(
            top: paddingTop,
            left: paddingLeft,
            bottom: paddingBottom,
            right: paddingRight
        )
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + paddingLeft + paddingRight
        let height = size.height + paddingTop + paddingBottom
        return CGSize(width: width, height: height)
    }
}
