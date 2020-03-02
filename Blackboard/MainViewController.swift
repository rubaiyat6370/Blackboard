//
//  ViewController.swift
//  Blackboard
//
//  Created by Rubaiyat Jahan Mumu on 2020-02-26.
//  Copyright © 2020 Rubaiyat Jahan Mumu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var drawPath: UIBezierPath =  UIBezierPath()

    var isFirstTouch: Bool = true

    var startPoint: CGPoint? {
        didSet {
            if let point = startPoint {
                previousPoint = point
                drawPath.move(to: point)
            }
        }
    }

    var previousPoint: CGPoint?

    var shapeLayer: CAShapeLayer = CAShapeLayer()

    var translationPoint: CGPoint? {
        didSet {
            if let point = translationPoint {
                self.drawPath.addLine(to: point)
                self.shapeLayer.path = self.drawPath.cgPath
                previousPoint = point
                print(point)
            }
        }
    }

    var lineWidth: CGFloat = 3.0
    var strokeColor: UIColor = .black

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        view.layer.addSublayer(shapeLayer)
        addPanGestureTo(view: self.view)

    }

    func addPanGestureTo(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }

    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let translation  = sender.translation(in: self.view)
        translationPoint = CGPoint(x: previousPoint!.x + translation.x, y: previousPoint!.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }

}

extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        startPoint = touch.location(in: self.view)
        return true
    }
}

