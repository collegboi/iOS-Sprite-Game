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
    var velocity: CGVector!
    
    let textureBk: SKTexture!
    let textureFd: SKTexture!
    let textureLt: SKTexture!
    let textureRt: SKTexture!

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init() {
        
        let atlas = SKTextureAtlas(named: "characters")
        textureBk = atlas.textureNamed("minnion_back")
        textureFd = atlas.textureNamed("minnion_front")
        textureLt = atlas.textureNamed("minnion_left")
        textureRt = atlas.textureNamed("minnion_right")
        textureFd.filteringMode = .Nearest
        textureBk.filteringMode = .Nearest
        textureRt.filteringMode = .Nearest
        textureLt.filteringMode = .Nearest
        
        sprite = SKSpriteNode(texture: textureBk)
        //self.velocity = CGVector(angle: 0)
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
        physicsBody?.applyImpulse(velocity)
        self.velocity = velocity
        playerDirection()
    }
    
    func actionJumpSprite() {
        
        let actionJump1 = SKAction.scaleTo(1.2, duration: 0.2)
        let actionJump2 = SKAction.scaleTo(1, duration: 0.2)
        
        let wait = SKAction.waitForDuration(0.25)
        
        let sequence = SKAction.sequence([actionJump1, actionJump2])
        
        sprite.runAction(sequence)
        
    }
    
    func playerDirection() {
        
        let direction = physicsBody!.velocity
        if abs(direction.dy) > abs(direction.dx) {
            if direction.dy < 0 {
                sprite.texture = textureFd
            } else {
                sprite.texture = textureBk
            }
        } else {
            if direction.dx  > 0 {
              sprite.texture = textureRt
            } else {
                sprite.texture = textureLt
            }
        }//if statement to see if sprite is moving direciton
    }
    
    
    

}
