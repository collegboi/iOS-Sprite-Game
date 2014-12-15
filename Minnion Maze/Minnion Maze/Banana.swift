//
//  Banana.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 15/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//


import SpriteKit

class Banana : SKNode {
    
    let sprite: SKSpriteNode
    let groundTexture: SKTexture
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(bananaTexture: SKTexture, groundTexture: SKTexture) {
        sprite = SKSpriteNode(texture: bananaTexture)
        self.groundTexture = groundTexture
        super.init()
        
        addChild(sprite)
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: sprite.size.width * 0.8, height: sprite.size.height * 0.8))
        physicsBody!.categoryBitMask = PhysicsCategory.Banana
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
    }
    
    func getBanana() {
        physicsBody = nil
        sprite.texture = groundTexture
        sprite.size = groundTexture.size()
        getPoint()
    }
    
    func getPoint() {
        
        let pointsLabel: SKLabelNode = SKLabelNode(fontNamed: "AvenirNext-Regular")
        pointsLabel.text = "1"
        pointsLabel.fontSize = 40
        pointsLabel.fontColor = SKColor.whiteColor()
        pointsLabel.position = sprite.position
        
       // addChild(pointsLabel)
        
        //let pointSequence = SKAction.sequence([SKAction.fadeOutWithDuration(2), SKAction.scaleTo(2, duration: 1), SKAction.removeFromParent()])
        
        //runAction(pointSequence)
    }
}