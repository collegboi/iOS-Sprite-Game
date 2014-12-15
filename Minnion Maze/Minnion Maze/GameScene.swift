//
//  GameScene.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 13/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//

import SpriteKit
import CoreMotion


class GameScene: SKScene, SKPhysicsContactDelegate {

    //single instance of CMMotionManager to ger reliable data
    let motionManager: CMMotionManager = CMMotionManager()
    
    var worldNode: SKNode!
    var backGroundLayer: TileMapLayer!
    var player: Player!
    
    var maxSpeed = 0.05
    let steerDeadZone = CGFloat(0.15)
    
    let ay = Vector3(x: 0.63, y: 0.0, z: -0.92)
    let az = Vector3(x: 0.0, y: 1.0, z: 0.0)
    let ax = Vector3.crossProduct(Vector3(x: 0.0, y: 1.0, z: 0.0),
        right: Vector3(x: 0.63, y: 0.0, z: -0.92)).normalized()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    
    override func didMoveToView(view: SKView) {
        
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates()
        userInteractionEnabled = true //enable to receiver taps on screen
        createWorld()
        createPlayer()
        centerViewOn(player.position)
    }
    

    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
        player.actionJumpSprite()
        //centerViewOn(touch.locationInNode(worldNode))
    }
    
   
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        worldNode.runAction(
            SKAction.screenZoomWithNode(worldNode,
                amount: CGPoint(x: 0.6, y: 0.6),
                oscillations: 1, duration:5)
        )
    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //centerViewOn(player.position)
       movePlayerWithAccerlerometer()
    }
    

    func movePlayerWithAccerlerometer() {
    
        var accel2D = CGPoint.zeroPoint
    
        if motionManager.accelerometerData == nil {
            println("no acceleration data yet")
            return
        }
    
        var raw = Vector3(
            x: CGFloat(motionManager.accelerometerData.acceleration.x),
            y: CGFloat(motionManager.accelerometerData.acceleration.y),
            z: CGFloat(motionManager.accelerometerData.acceleration.z))
        //raw = lowPassWithVector(raw)
    
        accel2D.x = Vector3.dotProduct(raw, right: az)
        accel2D.y = Vector3.dotProduct(raw, right: ax)
        accel2D.normalize()
    
        if abs(accel2D.x) < steerDeadZone {
            accel2D.x = 0
        }
    
        if abs(accel2D.y) < steerDeadZone {
            accel2D.y = 0
        }
    
        let maxAccelerationPerSecond = maxSpeed
        
        var velocity = CGVector(
            dx: accel2D.x * CGFloat(maxAccelerationPerSecond),
            dy: accel2D.y * CGFloat(maxAccelerationPerSecond))
        
         player.moveSprite(velocity)
    }
    
    override func didSimulatePhysics() {
        let target = getCenterPointWithTarget(player.position)
        worldNode.position += (target - worldNode.position) * 0.1
        centerViewOn(player.position)
    }
    
    
    func centerViewOn(centerOn: CGPoint) {
        worldNode.position = getCenterPointWithTarget(centerOn)
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
                "xxxxxxxxxooooooxooooooooooooooox",
                "xooooooooooooooxooooooooooooooox",
                "xooooooooooooooxooooooooooooooox",
                "xooooobooooboxooooooooooooooooox",
                "xoboxxxoooxxxxoooooooooooooooox",
                "xoooxoooooooooooooooooooooooooox",
                "xoooxoooooooooooooooooooooooooox",
                "xoooxxxxxxxxxxxxxxxxxxxxxxxxxxx"])
        
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
        player.position = CGPoint(x: 50, y: 50)
        worldNode.addChild(player)
    }
    
     func didBeginContact(contact: SKPhysicsContact) {
        println("init contact")
        let other = (contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA)
        
        switch other.categoryBitMask {
        case PhysicsCategory.Banana :
            let getPoint = other.node as Banana
            getPoint.getBanana()
            
        default:
            break;
        }
        
    }
    
    
}
