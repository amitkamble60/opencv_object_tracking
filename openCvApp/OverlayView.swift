//
//  OverlayView.swift
//  openCvApp
//
//  Created by Apple on 03/08/24.
//

import UIKit
import Foundation

/**
 This UIView draws overlay on a detected object.
 */
class OverlayView: UIView {
    
    var trackedObjectList: [TrackedObject] = []
    private let cornerRadius: CGFloat = 10.0
    private let stringBgAlpha: CGFloat = 0.7
    private let lineWidth: CGFloat = 3
    private let stringFontColor = UIColor.white
    private let stringHorizontalSpacing: CGFloat = 13.0
    private let stringVerticalSpacing: CGFloat = 7.0
    
    private let displayFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupView()
//    }
    
    private func setupView() {
        // Set the background color with transparency (e.g., 50% opacity)
        backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        
        // Add any other custom configuration or subviews here
        // For example, you can add labels, buttons, etc.
    }
    
    override func draw(_ rect: CGRect) {
        
        backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        // Drawing code
        for trackedObject in trackedObjectList {
            
            drawBorders(of: trackedObject)
//            drawBackground(of: trackedObject)
            drawName(of: trackedObject)
        }
    }
    
    /**
     This method draws the borders of the detected objects.
     */
    func drawBorders(of trackedObject: TrackedObject) {
        
        let path = UIBezierPath(rect: trackedObject.getBoundingBox())
        path.lineWidth = lineWidth
//        trackedObject.color.setStroke()
        path.stroke()
    }
    
//    /**
//     This method draws the background of the string.
//     */
//    func drawBackground(of trackedObject: TrackedObject) {
//
//        let stringBgRect = CGRect(x: trackedObject.getBoundingBox().origin.x, y: trackedObject.getBoundingBox().origin.y , width: 2 * stringHorizontalSpacing + trackedObject.getBoundingBox().width, height: 2 * stringVerticalSpacing + trackedObject.getBoundingBox().height
//        )
//
//        let stringBgPath = UIBezierPath(rect: stringBgRect)
////        trackedObject.color.withAlphaComponent(stringBgAlpha).setFill()
//        stringBgPath.fill()
//    }
    
//    /**
//     This method draws the name of object overlay.
//     */
    
//    let size = objectDescription.size(withAttributes: [.font: self.displayFont])
    
    func drawName(of trackedObject: TrackedObject) {
        
        // Draws the string.
        let stringRect = CGRect(x: trackedObject.getBoundingBox().origin.x + stringHorizontalSpacing, y: trackedObject.getBoundingBox().origin.y + stringVerticalSpacing, width: 30, height: 30)

        let attributedString = NSAttributedString(string: trackedObject.getLable(), attributes: [NSAttributedString.Key.foregroundColor : stringFontColor, NSAttributedString.Key.font : self.displayFont])
        attributedString.draw(in: stringRect)
    }

}
