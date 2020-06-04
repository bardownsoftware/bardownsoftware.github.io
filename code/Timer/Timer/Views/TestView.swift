//
//  Timer
//
//  Created by bwk on Sat.12.Nov.16.
//  Copyright © 2016 Bar Down Software. All rights reserved.
//

import UIKit

@IBDesignable

class TestView: UIControl {

    @IBInspectable var progress: CGFloat = 0.0

    @IBInspectable var trackThickness:    CGFloat = 0.5
    @IBInspectable var progressThickness: CGFloat = 8.0

    @IBInspectable var handleRadius: CGFloat = 12

    @IBInspectable var margin: CGFloat = 0

    @IBInspectable var trackColor     = UIColor.lightGray
    @IBInspectable var progressColor  = UIColor.orange
    @IBInspectable var handleColor    = UIColor.white
    @IBInspectable var highlightColor = UIColor(white: 0.9, alpha: 1.0)

    var numberOfStops: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
    }

    func dialRadius() -> CGFloat {
        let diameter = min(bounds.width, bounds.height)
        let radius = 0.5 * diameter - margin - handleRadius
        return radius
    }

    func handleRect() -> CGRect {
        let centre = CGPoint(x: bounds.midX, y: bounds.midY)
        let angle = progress * 2 * CGFloat(M_PI) - CGFloat(M_PI_2)
        let radius = dialRadius()

        let x = cos(angle) * radius
        let y = sin(angle) * radius

        let rect = CGRect(
            x: centre.x - handleRadius + x,
            y: centre.y - handleRadius + y,
            width: 2.0 * handleRadius,
            height: 2.0 * handleRadius)

        return rect
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()

        let centre = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = dialRadius()

        //  Track.
        //
        context?.beginPath()
        context?.addArc(center: centre,
                        radius: radius,
                        startAngle: 0,
                        endAngle: 2 * CGFloat(M_PI),
                        clockwise: false)

        context?.setStrokeColor(trackColor.cgColor)
        context?.setLineWidth(trackThickness)
        context?.strokePath()

        drawHandle(context!)

        drawProgress(context!)

        context?.restoreGState()
    }

    func drawHandle(_ context: CGContext) {
        if isUserInteractionEnabled {
            let rect = handleRect()

            let fillColour = isHighlighted ? highlightColor : handleColor

            context.setFillColor(fillColour.cgColor)
            context.setStrokeColor(trackColor.cgColor)
            context.setLineWidth(trackThickness)
            context.fillEllipse(in: rect)
            context.strokeEllipse(in: rect)
        }
    }

    func drawProgress(_ context: CGContext) {
        if !isUserInteractionEnabled {

            let startAngle = -CGFloat(M_PI_2)
            let endAngle = progress * 2 * CGFloat(M_PI) - CGFloat(M_PI_2)

            context.beginPath()
            context.addArc(
                center: center,
                radius: dialRadius(),
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false)

            context.setStrokeColor(progressColor.cgColor)
            context.setLineWidth(progressThickness)
            context.setLineCap(.round)
            context.strokePath()
        }
    }
}
