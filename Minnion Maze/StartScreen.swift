//
//  StartScreen.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 15/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//

import Foundation
import SpriteKit

class StartScreen: SKScene {
    
    let startButton: SKSpriteNode = SKSpriteNode(imageNamed: "start")
    var level: Int = 0
    var score: Int = 0
    
    override func didMoveToView(view: SKView) {
        
        let background = SKSpriteNode(imageNamed:"startScreenBckgd@1x")
        background.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        self.addChild(background)
        
        startButton.position = CGPoint(x: self.size.width * 0.15, y: self.size.height * 0.2)
        self.addChild(startButton)
        
        self.userInteractionEnabled  = true
    }
    
    func sceneTapped() {
        let myScene = GameScene(size:self.size, levelCounter: level)
        myScene.scaleMode = scaleMode
        let reveal = SKTransition.doorwayWithDuration(1.5)
        self.view?.presentScene(myScene, transition: reveal)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)  {
    
        var touch: UITouch = touches.allObjects[0] as UITouch
        var location: CGPoint = touch.locationInNode(self)
        
        if startButton.containsPoint(location) {
            sceneTapped()
        }
    }

}
