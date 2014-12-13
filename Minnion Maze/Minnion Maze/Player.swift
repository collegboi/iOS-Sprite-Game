//
//  Player.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 13/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//

import SpriteKit

class Player : SKNode {
    
    let sprite: SKSpriteNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init() {
        let atlas = SKTextureAtlas(named: "characters")
        let texture = atlas.textureNamed("Minnion_1")
        texture.filteringMode = .Nearest
        
        sprite = SKSpriteNode(texture: texture)
        
        super.init()
        
        addChild(sprite)
        name = "player"
        
        
        //
        var minDiam = min(sprite.size.width, sprite.size.height)
        minDiam = max(minDiam-16.0, 4.0)
        let physicsBody = SKPhysicsBody(circleOfRadius: minDiam/2.0)
        //
        physicsBody.usesPreciseCollisionDetection = true
        //
        physicsBody.allowsRotation = false
        physicsBody.restitution = 1
        physicsBody.friction = 0
        physicsBody.linearDamping = 0
        //
        self.physicsBody = physicsBody
    }
    
    
    
    func moveSprite(velocity: CGVector) {
        
        println(velocity.dx)
        println(velocity.dy)
        sprite.position.x += velocity.dx
        sprite.position.y += velocity.dy
        
    }
}

