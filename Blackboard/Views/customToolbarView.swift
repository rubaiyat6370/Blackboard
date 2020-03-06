//
//  customToolbarView.swift
//  Blackboard
//
//  Created by Rubaiyat Jahan Mumu on 2020-03-03.
//  Copyright © 2020 Rubaiyat Jahan Mumu. All rights reserved.
//

import UIKit

class customToolbarView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func setupView() {
        layer.cornerRadius = 10
        layer.masksToBounds = true
        layer.opacity = 0.5
        backgroundColor = .gray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

}
