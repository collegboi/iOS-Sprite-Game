//
//  AnalogControl.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 13/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//

import UIKit

protocol AnalogControlPositionChange {
    func analogControlPositionChanged(
        analogControl: AnalogControl, position: CGPoint)
}

class AnalogControl: UIView {

    let baseCenter: CGPoint
    let knobImageView: UIImageView
    var relativePostion: CGPoint!
    
    var delegate: AnalogControlPositionChange?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(frame viewFrame: CGRect) {
        
        baseCenter = CGPoint(x: viewFrame.size.width / 2, y: viewFrame.size.height / 2)
        
        knobImageView = UIImageView(image: UIImage(named: "knob"))
        knobImageView.frame.size.width /= 2
        knobImageView.frame.size.height /= 2
        knobImageView.center = baseCenter
        
        super.init(frame: viewFrame)
        
        userInteractionEnabled = true
        
        let baseImageView = UIImageView(frame: bounds)
        baseImageView.image = UIImage(named: "base")
        addSubview(baseImageView)
        
        addSubview(knobImageView)
        
        
        assert(CGRectContainsRect(bounds, knobImageView.bounds),
            "Analog contol should be larger than the knob in size")
    } 

    
    func updateKnobWithPosition(postion: CGPoint) {
        
        var postionToCenter = postion - baseCenter
        var direction : CGPoint
        
        if postionToCenter == CGPointZero {
            direction = CGPointZero
        } else {
            direction = postionToCenter.normalized()
        }
        
        let radius = frame.size.width / 2
        var length = postionToCenter.length()
        
        if length > radius {
            length = radius
            postionToCenter = direction * radius
        }
        
        let relPosition = CGPoint(x: direction.x * (length/radius), y: direction.y * (length/radius))
        
        knobImageView.center = baseCenter + postionToCenter
        relativePostion = relPosition
        
        delegate?.analogControlPositionChanged(self, position: relativePostion)
    }
    
    
    override func touchesBegan(touches: NSSet,
        withEvent event: UIEvent) {
            
            let touchLocation = touches.anyObject()!.locationInView(self)
            updateKnobWithPosition(touchLocation)
    }
    
    override func touchesMoved(touches: NSSet,
        withEvent event: UIEvent) {
            
            let touchLocation = touches.anyObject()!.locationInView(self)
            updateKnobWithPosition(touchLocation)
    }
    
    override func touchesEnded(touches: NSSet,
        withEvent event: UIEvent) {
            
            updateKnobWithPosition(baseCenter)
    }
    
    override func touchesCancelled(touches: NSSet,
        withEvent event: UIEvent) {
            
            updateKnobWithPosition(baseCenter)
    }


}
