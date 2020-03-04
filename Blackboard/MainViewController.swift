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

    var layers = [CAShapeLayer]()

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

    var currentLayer: CAShapeLayer!

    var translationPoint: CGPoint? {
        didSet {
            if let point = translationPoint {
                self.drawPath.addLine(to: point)
                self.currentLayer.path = self.drawPath.cgPath
                previousPoint = point
                print(point)
            }
        }
    }

    var mode = 1 // 1 for writing
    var lineWidth: CGFloat = 5.0
    var eraserLineWidth: CGFloat = 30
    var strokeColor: UIColor = .white
    var bgColor: UIColor = .black

    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var eraserButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        self.boardView.layer.masksToBounds = true
        self.boardView.backgroundColor = bgColor
        self.toolBarView.layer.zPosition = CGFloat(Int.max)
        addPanGestureTo(view: self.toolBarView)

    }

    //mode == 1 : writing mode
    func createNewLayer(_ mode:Int) {
        //setup shapeLayer
        currentLayer = CAShapeLayer()
        currentLayer.strokeColor = mode == 1 ? strokeColor.cgColor : bgColor.cgColor
        currentLayer.fillColor = UIColor.clear.cgColor
        currentLayer.lineWidth = mode == 1 ? lineWidth : eraserLineWidth // ( 30 for erase mode )
        currentLayer.lineCap = .round
        self.boardView.layer.addSublayer(currentLayer)
        layers.append(currentLayer)

        drawPath = UIBezierPath()
    }

    func addPanGestureTo(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        view.addGestureRecognizer(panGesture)
    }

    @IBAction func eraserClicked(_ sender: Any) {
        mode = 0
    }

    @IBAction func startWriting(_ sender: Any) {
        mode = 1
    }
   
    @IBAction func undoWriting(_ sender: Any) {
        if !layers.isEmpty {
            layers.last?.removeFromSuperlayer()
            layers.removeLast()
        }
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let translation  = sender.translation(in: self.boardView)
        let toolView = sender.view
        toolView?.center = CGPoint(x: toolView!.center.x + translation.x, y: toolView!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.boardView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self.boardView) {
            if toolBarView.frame.contains(point) {
                return
            }
            createNewLayer(mode)
            startPoint = point
        }

        print("began")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self.boardView) {
            translationPoint = point
            print("moved")

        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self.boardView) {
            translationPoint = point
            print("ended")
        }
    }

}
//
//extension MainViewController: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        startPoint = touch.location(in: self.boardView)
//        return true
//    }
//}

