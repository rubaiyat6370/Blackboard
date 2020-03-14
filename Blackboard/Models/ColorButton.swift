//
//  ColorButton.swift
//  Blackboard
//
//  Created by Rubaiyat Jahan Mumu on 2020-03-09.
//  Copyright © 2020 Rubaiyat Jahan Mumu. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ColorButton: UIButton {
    @IBInspectable var borderColor: UIColor = .white
    @IBInspectable var borderWidth: CGFloat = 5.0
    @IBInspectable var cornerRadius: CGFloat = 30
    @IBInspectable var fillColor: UIColor = .red
    @IBInspectable var colorName: String = "red"

    fileprivate func setup(_ rect: CGRect) {
        let path  = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        fillColor.setFill()
        path.fill()
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.layer.masksToBounds = true
    }

    override func draw(_ rect: CGRect) {
        setup(rect)
    }

}
