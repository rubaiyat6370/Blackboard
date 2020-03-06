//
//  SettingsView.swift
//  Blackboard
//
//  Created by Rubaiyat Jahan Mumu on 2020-03-05.
//  Copyright © 2020 Rubaiyat Jahan Mumu. All rights reserved.
//

import Foundation
import UIKit

class SettingsView: UIView {

    @IBOutlet weak var view: UIView!

    @IBOutlet weak var scrollview: UIScrollView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        Bundle.main.loadNibNamed("SettingsView", owner: self, options: nil)
        self.view.frame = self.frame
        
        self.addSubview(self.view)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)


        //fatalError("init(coder:) has not been implemented")
    }
}


