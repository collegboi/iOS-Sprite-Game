//
//  GameScene.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 13/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//

import SpriteKit


class GameScene: SKScene, AnalogControlPositionChange {

    var worldNode: SKNode!
    var backGroundLayer: TileMapLayer!
    var player: Player!
    var maxSpeed = 6
    
    var analogControl: AnalogControl!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    
    override func didMoveToView(view: SKView) {
        createWorld()
        createPlayer()
        centerViewOn(player.position)
    }
    

    
    func analogControlPositionChanged(analogControl: AnalogControl, position: CGPoint)  {
        
        var velocity = CGVector(
            dx: position.x * CGFloat(maxSpeed),
            dy: -position.y * CGFloat(maxSpeed))

        player.moveSprite(velocity)

        
        if position != CGPointZero {
               // player.sprite.zRotation = CGPointMake(position.x, -position.y).angle
        }
        //centerViewOn(player.position)
        centerViewOn(position)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        centerViewOn(touch.locationInNode(worldNode))
        player.actionJumpSprite()
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    override func didSimulatePhysics() {
        let target = getCenterPointWithTarget(player.position)
        worldNode.position += (target - worldNode.position) * 0.1
    }
    
    
    func centerViewOn(centerOn: CGPoint) {
        var playerPositin = getCenterPointWithTarget(centerOn)
        worldNode.position = playerPositin
    }

    func getCenterPointWithTarget(target: CGPoint) -> CGPoint {
        let x = target.x.clamped(
            size.width / 2,
            backGroundLayer.layerSize.width - size.width / 2)
        let y = target.y.clamped(
            size.height / 2,
            backGroundLayer.layerSize.height - size.height / 2)
        
        return CGPoint(x: -x, y: -y)
    }
    
    
    func createScenery() -> TileMapLayer {
        
        return TileMapLayer(atlasName: "scenery",
            tileSize: CGSize(width: 32, height: 32),
            tileCodes: [
                "xooooooooooooooooowwwwwwwwwwwwwx",
                "xoooooooooooooooooowwwwwwwwwwwwx",
                "oooooooooooooooooowwwwwwwwwwwwwx",
                "xoooooooooooooooooooowwwwwwwwwwx",
                "xoooooooooooooooooooowwwwwwwwwwx",
                "xooooooooooooooooooooowwwwwwwwwx",
                "xooooooooooooooooooooowwwwwwwwwx",
                "xoooooooooooooooooooooowwwwwwwwx",
                "xoooooooooooooooooooooooowwwwwwx",
                "x======oooooooooooooooooooowwwwx",
                "x======oooooooooooooooooooooooox",
                "x======oooooooooooooooooooooooox",
                "x======oooooooooooooooooooooooox",
                "x==============xooooooooooooooox",
                "x==============xooooooooooooooox",
                "x==============xooooooooooooooox",
                "x==========xxxxxooooooooooooooox",
                "xxxxxxxxxxxxooooooooooooooooooox",
                "xoooooooooooooooooooooooooooooox",
                "xoooooooooooooooooooooooooooooox",
                "xoooooooooooooooooooooooooooooox",
                "xoooooooooooooooooooooooooooooox",
                "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"])
        
    }
    
    func createWorld() {
        backGroundLayer = createScenery()
        
        worldNode = SKNode()
        worldNode.addChild(backGroundLayer)
        addChild(worldNode!)
        
        anchorPoint = CGPointMake(0.5, 0.5)
        worldNode.position =
            CGPointMake(-backGroundLayer.layerSize.width / 2,
                -backGroundLayer.layerSize.height / 2)
        
        
        let bounds = SKNode()
        bounds.physicsBody = SKPhysicsBody(edgeLoopFromRect:
            CGRect(x: 0, y: 0,
                width: backGroundLayer.layerSize.width,
                height: backGroundLayer.layerSize.height))
        bounds.physicsBody!.categoryBitMask = PhysicsCategory.Boundary
        bounds.physicsBody!.friction = 0
        worldNode.addChild(bounds)
        
        self.physicsWorld.gravity = CGVector.zeroVector
    }
    
    func createPlayer() {
        
        player = Player()
        player.setScale(1)
        player.zPosition = 50
        player.position = CGPoint(x: 300, y: 50)
        worldNode.addChild(player)
    }
    
}
