//
//  ViewController.swift
//  Blackboard
//
//  Created by Rubaiyat Jahan Mumu on 2020-02-26.
//  Copyright © 2020 Rubaiyat Jahan Mumu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    //
    // MARK: - IBOutlets
    //

    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var eraserButton: UIButton!

    //
    // MARK: - Variables
    //

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
    var drawPath: UIBezierPath!
    var drawingLayers = [CAShapeLayer]()
    var actionMode = 1 // 1 for writing
    var lineWidth: CGFloat = 5.0
    var eraserLineWidth: CGFloat = 30
    var strokeColor: UIColor = .white
    var settingsView: SettingsView!
    var isSettingsTapped: Bool!
    var bgColor: UIColor = .black {
        didSet {
            self.view.backgroundColor = bgColor
        }
    }
    var strokeColorOpacity: CGFloat = 1.0

    override func viewDidLoad() {
       super.viewDidLoad()
       title = "Main"
       self.boardView.layer.masksToBounds = true
       self.view.backgroundColor = bgColor
       self.toolBarView.layer.zPosition = CGFloat(Int.max)
       addPanGestureTo(view: self.toolBarView)
       setupSettingsView()
    }

    fileprivate func setupSettingsView() {
        settingsView = SettingsView(frame: CGRect(x: 0, y: 0, width: 300, height: 450))
        settingsView.drawingDelegate = self
        settingsView.drawingBox = DrawingBox(bgColor: bgColor, pencilColor: strokeColor, pencitWidth: lineWidth, pencilOpacity: strokeColorOpacity)
        settingsView.center = view.center
        self.settingsView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        isSettingsTapped = false
        self.view.addSubview(settingsView)
    }

    //mode == 1 : writing mode
    func createNewLayer(_ mode:Int) {
        //setup shapeLayer
        currentLayer = CAShapeLayer()
        currentLayer.strokeColor = mode == 1 ? strokeColor.cgColor : bgColor.cgColor
        currentLayer.opacity = Float(mode == 1 ? strokeColorOpacity : 1.0)
        currentLayer.fillColor = UIColor.clear.cgColor
        currentLayer.lineWidth = mode == 1 ? lineWidth : eraserLineWidth // ( 30 for erase mode )
        currentLayer.lineCap = .round
        self.boardView.layer.addSublayer(currentLayer)
        drawingLayers.append(currentLayer)

        drawPath = UIBezierPath()
    }

    func addPanGestureTo(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        view.addGestureRecognizer(panGesture)
    }

    @IBAction func eraserClicked(_ sender: Any) {
        actionMode = 0
    }

    @IBAction func startWriting(_ sender: Any) {
        actionMode = 1
    }
   
    @IBAction func undoWriting(_ sender: Any) {
        if !drawingLayers.isEmpty {
            drawingLayers.last?.removeFromSuperlayer()
            drawingLayers.removeLast()
        }
    }

    @IBAction func settingsClicked(_ sender: Any) {
        settingsView.drawingBox = DrawingBox(bgColor: bgColor, pencilColor: strokeColor, pencitWidth: lineWidth, pencilOpacity: strokeColorOpacity)
        settingsView.setupView()
        if !isSettingsTapped {
            UIView.animate(withDuration: 1.0, animations: {
                self.settingsView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            isSettingsTapped = true
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                self.settingsView.transform = CGAffineTransform(scaleX: 0.000001, y: 0.000001) // if scale is set to 0 it does not animate
            })
            isSettingsTapped = false
        }
    }

    //
    // MARK: - Color Button Action
    //

    @IBAction func colorButtonPressed(_ sender: ColorButton) {
        self.strokeColor = sender.fillColor
        actionMode = 1
    }
}

//
// MARK: - DrawingProtocol Implemented
//
extension MainViewController: DrawingProtocol {
    func setProperties(prop: DrawingBox) {
        self.bgColor = prop.bgColor
        self.lineWidth = prop.pencitWidth
        self.strokeColor = prop.pencilColor
        self.strokeColorOpacity = prop.pencilOpacity
        settingsView.drawingBox = prop
    }
}

//
// MARK: - Gesture Recognizer & touch handling
//
extension MainViewController {
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let translation  = sender.translation(in: self.boardView)
        let toolView = sender.view
        toolView?.center = CGPoint(x: toolView!.center.x + translation.x, y: toolView!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.boardView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self.boardView) {
            createNewLayer(actionMode)
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



