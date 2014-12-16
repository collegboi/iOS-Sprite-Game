//
//  File.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 15/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//

import SpriteKit

class StartSceen: SKScene {
    
    let

    
    override func didMoveToView(view: SKView) {
        
        var backGroundImage = SKSpriteNode(imageNamed: "startScreenBckgd@1x")
        backGroundImage.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)
        addChild(backGroundImage)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {

        
    }
    
}
