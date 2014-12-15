//
//  Banana.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 15/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//

import SpriteKit

class Banana : SKNode {
    
    let sprite : SKSpriteNode
    let ground : SKTexture
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    
    init(banana1: SKTexture, ground: SKTexture) {
        
        self.ground = ground
        sprite = SKSpriteNode(texture: banana1)
        super.init()
        
        addChild(sprite)
        
        physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: sprite.size.width * 0.6, height: sprite.size.height * 0.6))
        physicsBody!.categoryBitMask = PhysicsCategory.Banana
        physicsBody!.collisionBitMask = PhysicsCategory.None
        physicsBody!.contactTestBitMask = PhysicsCategory.Player
        
    }
    
    func getBanana() {
        println("contact")
        physicsBody = nil
        sprite.texture = ground
        sprite.size = ground.size()
    }
    
}
