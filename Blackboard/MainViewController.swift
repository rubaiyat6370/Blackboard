//
//  ViewController.swift
//  Blackboard
//
//  Created by Rubaiyat Jahan Mumu on 2020-02-26.
//  Copyright © 2020 Rubaiyat Jahan Mumu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var drawPath: UIBezierPath!
    var eraserPath: UIBezierPath =  UIBezierPath()
    var writingPath: UIBezierPath =  UIBezierPath()

    @IBOutlet weak var boardView: UIView!

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

    var shapeLayer: CAShapeLayer!
    var eraserLayer: CAShapeLayer = CAShapeLayer()
    var writingLayer: CAShapeLayer = CAShapeLayer()

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
    var strokeColor: UIColor = .white
    var bgColor: UIColor = .black

    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var eraserButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        //shapeLayer.frame = self.boardView.frame

        //setup shapeLayer
        shapeLayer = writingLayer
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        drawPath = writingPath

        //setup eraserlayer
        eraserLayer.fillColor = UIColor.clear.cgColor
        eraserLayer.strokeColor = bgColor.cgColor
        eraserLayer.lineWidth = 20

        self.boardView.layer.addSublayer(shapeLayer)
        self.boardView.layer.addSublayer(eraserLayer)
        self.boardView.layer.masksToBounds = true
        self.boardView.backgroundColor = bgColor
        addPanGestureTo(view: self.boardView)

    }

    func addPanGestureTo(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        //panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }

    @IBAction func eraserClicked(_ sender: Any) {
        drawPath = eraserPath
        shapeLayer = eraserLayer
    }

    @IBAction func startWriting(_ sender: Any) {
        drawPath = writingPath
        shapeLayer = writingLayer
        writingLayer.zPosition = 100
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let translation  = sender.translation(in: self.boardView)
        translationPoint = CGPoint(x: previousPoint!.x + translation.x, y: previousPoint!.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.boardView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startPoint = touches.first?.location(in: self.boardView)
    }

}
//
//extension MainViewController: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        startPoint = touch.location(in: self.boardView)
//        return true
//    }
//}

