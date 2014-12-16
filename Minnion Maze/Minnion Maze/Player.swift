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
        let texture = atlas.textureNamed("minnion_1")
        texture.filteringMode = .Nearest
        
        sprite = SKSpriteNode(texture: texture)
        
        super.init()
        
        addChild(sprite)
        name = "player"
        
        
        //
        var minDiam = min(sprite.size.width, sprite.size.height)
        minDiam = max(minDiam - 4.0, 1.0)
        let physicsBody = SKPhysicsBody(circleOfRadius: minDiam / 8.0 )
        //let physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
        //
        physicsBody.usesPreciseCollisionDetection = true
        //
        physicsBody.allowsRotation = false
        physicsBody.restitution = 0
        physicsBody.friction = 0
        physicsBody.linearDamping = 0
        physicsBody.categoryBitMask = PhysicsCategory.Player
        physicsBody.contactTestBitMask = PhysicsCategory.All
        physicsBody.collisionBitMask = PhysicsCategory.Boundary | PhysicsCategory.Wall
        
        self.physicsBody = physicsBody
    }
    
    
    
    func moveSprite(velocity: CGVector) {
        //sprite.position.x += velocity.dx
        //sprite.position.y += velocity.dy
       // physicsBody?.velocity = CGVector(dx: velocity.dx, dy: velocity.dy)
        physicsBody?.applyImpulse(velocity)
    }
    
    func moveToward(target: CGPoint) {
        let targetVector = (target - position).normalized() * 300.0
        physicsBody?.velocity = CGVector(point: targetVector)
    }
        
    func actionJumpSprite() {
        
        let actionJump1 = SKAction.scaleTo(1.2, duration: 0.2)
        let actionJump2 = SKAction.scaleTo(1, duration: 0.2)
        
        let wait = SKAction.waitForDuration(0.25)
        
        let sequence = SKAction.sequence([actionJump1, actionJump2])
        
        sprite.runAction(sequence)
        
    }
    
    
    

}
