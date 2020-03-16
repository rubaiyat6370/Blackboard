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

    //
    // MARK: - Variables
    //

    var canvas = Canvas()
    var settingsView: SettingsView!
    var isSettingsTapped: Bool!
    var bgColor: UIColor = .black {
        didSet {
            self.view.backgroundColor = bgColor
            canvas.bgColor = bgColor
        }
    }
    var strokeColorOpacity: CGFloat = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        setupCanvas()
        addPanGestureTo(view: self.toolBarView)
        setupSettingsView()
    }

    fileprivate func setupCanvas() {
        self.boardView.addSubview(canvas)
        //canvas.frame = UIScreen.main.bounds
        canvas.translatesAutoresizingMaskIntoConstraints = false
        canvas.topAnchor.constraint(equalTo: boardView.topAnchor).isActive = true
        canvas.leadingAnchor.constraint(equalTo: boardView.leadingAnchor).isActive = true
        canvas.trailingAnchor.constraint(equalTo: boardView.trailingAnchor).isActive = true
        canvas.bottomAnchor.constraint(equalTo: boardView.bottomAnchor).isActive = true
        self.boardView.layer.masksToBounds = true
        self.view.backgroundColor = bgColor
        self.boardView.sendSubviewToBack(canvas)
    }


    fileprivate func setupSettingsView() {

        settingsView = SettingsView(frame: CGRect(x: 0, y: 0, width: 300, height: 450))
        //settingsView.translatesAutoresizingMaskIntoConstraints = false
        settingsView.drawingDelegate = self
        settingsView.drawingBox = DrawingBox(bgColor: bgColor, pencilColor: canvas.strokeColor, pencitWidth: canvas.lineWidth, pencilOpacity: strokeColorOpacity)
        settingsView.center = view.center
        self.settingsView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        isSettingsTapped = false
        self.boardView.addSubview(settingsView)
    }

    func addPanGestureTo(view: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        view.addGestureRecognizer(panGesture)
    }

    @IBAction func eraserClicked(_ sender: Any) {
        //actionMode = 0
        canvas.actionMode = 0
    }

    @IBAction func startWriting(_ sender: Any) {
        canvas.actionMode = 1
    }
   
    @IBAction func undoWriting(_ sender: Any) {
        canvas.undo()
    }

    func updateSettingsView() {
        settingsView.drawingBox = DrawingBox(bgColor: bgColor, pencilColor: canvas.strokeColor, pencitWidth: canvas.lineWidth, pencilOpacity: strokeColorOpacity)
    }

    @IBAction func settingsClicked(_ sender: Any) {
        updateSettingsView()
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

    @IBAction func colorMode(_ sender: Any) {
        canvas.actionMode = 3 // color mode
        updateSettingsView()
    }

    //
    // MARK: - Color Button Action
    //

    @IBAction func colorButtonPressed(_ sender: ColorButton) {
        canvas.strokeColor =  sender.fillColor // colorMap[sender.colorName]!
        canvas.actionMode = 1
    }
}

//
// MARK: - DrawingProtocol Implemented
//
extension MainViewController: DrawingProtocol {
    func setProperties(prop: DrawingBox) {
        self.bgColor = prop.bgColor
        canvas.lineWidth = prop.pencitWidth
        canvas.strokeColor = prop.pencilColor
        canvas.strokeColorOpacity = prop.pencilOpacity
        settingsView.drawingBox = prop
    }
}

//
// MARK: - Gesture Recognizer & touch handling
//
extension MainViewController {
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let translation  = sender.translation(in: self.view)
        let toolView = sender.view
        toolView?.center = CGPoint(x: toolView!.center.x + translation.x, y: toolView!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    // unused now
    fileprivate func tapTarget(for layer: CAShapeLayer) -> UIBezierPath? {
        guard let path = layer.path else {
            return nil
        }

        let targetPath = path.copy(strokingWithWidth: layer.lineWidth, lineCap: CGLineCap.round, lineJoin: CGLineJoin.round, miterLimit: layer.miterLimit)

        return UIBezierPath.init(cgPath: targetPath)
    }
}



