//
//  Canvas.swift
//  Blackboard
//
//  Created by Rubaiyat Jahan Mumu on 2020-03-15.
//  Copyright © 2020 Rubaiyat Jahan Mumu. All rights reserved.
//

import UIKit

class Canvas: UIView {
    var startPoint: CGPoint? {
       didSet {
           if let point = startPoint {
               //drawPath.move(to: point)
               previousPoint = point
           }
       }
   }
   var previousPoint: CGPoint?
   var currentLayer: CAShapeLayer!
   var translationPoint: CGPoint? {
       didSet {
           if let point = translationPoint {
               if let pre = previousPoint {
                   drawPath.move(to: pre)
               } else {
                   drawPath.move(to: point)
               }
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
   //var settingsView: SettingsView!
   //var isSettingsTapped: Bool!
   var bgColor: UIColor = .black {
       didSet {
           self.backgroundColor = bgColor
       }
   }
   var strokeColorOpacity: CGFloat = 1.0

    func undo() {
        if !drawingLayers.isEmpty {
            drawingLayers.last?.removeFromSuperlayer()
            drawingLayers.removeLast()
        }
    }

    func createNewLayer(_ mode:Int) {
        //setup shapeLayer
        currentLayer = CAShapeLayer()
        currentLayer.strokeColor = (mode == 1 || mode == 3) ? strokeColor.cgColor : bgColor.cgColor
        currentLayer.opacity = Float((mode == 1 || mode == 3) ? strokeColorOpacity : 1.0)
        currentLayer.fillColor = UIColor.clear.cgColor
        currentLayer.lineWidth = lineWidth
        currentLayer.lineCap = .round

        self.layer.addSublayer(currentLayer)
        if mode != 3 {
            drawingLayers.append(currentLayer)
        }

        drawPath = UIBezierPath()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            if actionMode != 3 {
                self.createNewLayer(actionMode)
                self.startPoint = point
            } else {

                for layer in self.drawingLayers {
                    if layer.path!.contains(point) {
                        self.createNewLayer(actionMode)
                        self.startPoint = point
                    }
                }
            }
        }

        //print("began")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            if actionMode != 3 {
                translationPoint = point
                //print("moved")
            } else {
                if previousPoint == nil {
                    self.createNewLayer(actionMode)
                }
                for layer in self.drawingLayers {
                    if layer.path!.contains(point) {
                        translationPoint = point
                    }
                }
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            if actionMode != 3 {
                translationPoint = point
                //print("ended")
            } else {
                for layer in self.drawingLayers {
                    if layer.path!.contains(point) {
                        translationPoint = point
                    }
                }
            }
        }
        previousPoint = nil
    }
}
