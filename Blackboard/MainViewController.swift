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
    var bgColor: UIColor = .black {
        didSet {
            self.view.backgroundColor = bgColor
        }
    }
    var opacity: CGFloat = 1.0

    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var eraserButton: UIButton!
    var settings: SettingsView!
    var isSettingsTapped: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        self.boardView.layer.masksToBounds = true
        self.view.backgroundColor = bgColor
        self.toolBarView.layer.zPosition = CGFloat(Int.max)
        addPanGestureTo(view: self.toolBarView)

        settings = SettingsView(frame: CGRect(x: 0, y: 0, width: 300, height: 450))
        settings.drawingDelegate = self
        settings.drawingBox = DrawingBox(bgColor: bgColor, pencilColor: strokeColor, pencitWidth: lineWidth, pencilOpacity: opacity)
        settings.center = view.center
        self.settings.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        isSettingsTapped = false
        self.view.addSubview(settings)
    }

    //mode == 1 : writing mode
    func createNewLayer(_ mode:Int) {
        //setup shapeLayer
        currentLayer = CAShapeLayer()
        currentLayer.strokeColor = mode == 1 ? strokeColor.cgColor : bgColor.cgColor
        currentLayer.opacity = Float(mode == 1 ? opacity : 1.0)
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

    @IBAction func settingsClicked(_ sender: Any) {
        settings.drawingBox = DrawingBox(bgColor: bgColor, pencilColor: strokeColor, pencitWidth: lineWidth, pencilOpacity: opacity)
        settings.setupView()
        if !isSettingsTapped {
            UIView.animate(withDuration: 1.0, animations: {
                self.settings.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
            isSettingsTapped = true
        } else {
            UIView.animate(withDuration: 1.0, animations: {
                self.settings.transform = CGAffineTransform(scaleX: 0.000001, y: 0.000001) // if scale is set to 0 it does not animate
            })
            isSettingsTapped = false
        }
    }

    //
    // MARK: - Color Button Action
    //

    //
    // MARK: - 1st row
    //
    @IBAction func blackButtonPressed(_ sender: UIButton) {
        //system black
        self.strokeColor = UIColor.black
    }

    @IBAction func blueButtonPressed(_ sender: UIButton) {
        //system blue
        self.strokeColor = UIColor.blue
    }

    @IBAction func greenPressed(_ sender: UIButton) {
        //system green
        self.strokeColor = UIColor.green
    }

    @IBAction func redPressed(_ sender: UIButton) {
        //system red
        self.strokeColor = UIColor.red
    }
    @IBAction func indigoPressed(_ sender: Any) {
        //system indigo
        self.strokeColor = UIColor(red: 88.0/255.0, green: 86.0/255.0, blue: 214.0/255.0, alpha: 1.0)
    }

    @IBAction func peachPressed(_ sender: UIButton) {
        // red 255 green 136 blue 92
        self.strokeColor = UIColor(red: 255.0/255.0, green: 136.0/255.0, blue: 92.0/255.0, alpha: 1.0)
    }

    //
    // MARK: - 2nd row
    //

    @IBAction func whitePressed(_ sender: UIButton) {
        //system white
        self.strokeColor = UIColor.white
    }

    @IBAction func yellowPressed(_ sender: UIButton) {
        //system yellow
        self.strokeColor = UIColor.yellow
    }

    @IBAction func purplePressed(_ sender: UIButton) {
        //system purple
        self.strokeColor = UIColor(red: 174.0/255.0, green: 37.0/255.0, blue: 204.0/255.0, alpha: 1.0)
    }

    @IBAction func orangePressed(_ sender: UIButton) {
        //system orange
        self.strokeColor = UIColor.orange
    }

    @IBAction func pinkPressed(_ sender: UIButton) {
        //system pink
        self.strokeColor = UIColor(red: 255.0/255.0, green: 45.0/255.0, blue: 188.0/255.0, alpha: 1.0)
    }

    @IBAction func darkGreenPressed(_ sender: UIButton) {
        //rgb - 52, 115, 0
        self.strokeColor = UIColor(red: 52.0/255.0, green: 115.0/255.0, blue: 0.0, alpha: 1.0)
    }

}

extension MainViewController: DrawingProtocol {
    func setProperties(prop: DrawingBox) {
        self.bgColor = prop.bgColor
        self.lineWidth = prop.pencitWidth
        self.strokeColor = prop.pencilColor
        self.opacity = prop.pencilOpacity
        settings.drawingBox = prop
    }
}



