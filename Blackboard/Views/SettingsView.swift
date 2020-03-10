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
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var lineWidthSlider: UISlider!

    @IBOutlet weak var opacitySlider: UISlider!

    weak var drawingDelegate: DrawingProtocol?
    var drawingBox: DrawingBox!

    fileprivate func loadView(_ frame: CGRect) {
        self.frame = frame
        Bundle.main.loadNibNamed("SettingsView", owner: self, options: nil)
        self.view.frame = frame
        self.addSubview(self.view)
    }

    func setupView() {
        lineWidthSlider.setValue(Float(drawingBox.pencitWidth), animated: false)
        opacitySlider.setValue(Float(drawingBox.pencilOpacity), animated: false)
        displayView.backgroundColor = drawingBox.bgColor
        drawPreview()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView(frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @IBAction func selectBlackBoard(_ sender: Any) {
        drawingBox.bgColor = UIColor.black
        drawingDelegate?.setProperties(prop: drawingBox)
        drawPreview()
    }
    
    @IBAction func selectWhiteBoard(_ sender: Any) {
        drawingBox.bgColor = UIColor.white
        drawingDelegate?.setProperties(prop: drawingBox)
        drawPreview()
    }
    
    @IBAction func selectBlueColor(_ sender: Any) {
        drawingBox.pencilColor = UIColor.systemBlue
        drawingDelegate?.setProperties(prop: drawingBox)
        drawPreview()
    }

    @IBAction func lineWidthChanged(_ sender: UISlider) {
        drawingBox.pencitWidth = CGFloat(sender.value)
        drawingDelegate?.setProperties(prop: drawingBox)
        drawPreview()
    }

    @IBAction func opacityChanged(_ sender: UISlider) {
        drawingBox.pencilOpacity = CGFloat(sender.value)
        drawingDelegate?.setProperties(prop: drawingBox)
        drawPreview()
    }
    
    func drawPreview() {

        UIGraphicsBeginImageContext(previewImageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
          return
        }
        displayView.backgroundColor = drawingBox.bgColor
        context.setLineCap(.round)
        context.setLineWidth(drawingBox.pencitWidth)
        context.setStrokeColor(drawingBox.pencilColor.cgColor)
        context.setAlpha(drawingBox.pencilOpacity)
        context.move(to: CGPoint(x: 20, y: 20))
        context.addQuadCurve(to: CGPoint(x: 100, y: 60), control: CGPoint(x: 50, y: 50))
        context.strokePath()
        previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
     }
}


