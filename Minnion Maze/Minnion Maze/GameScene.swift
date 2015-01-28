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
    var zoomMap: SKSpriteNode!
    var gameViewControl = GameViewController?()
    var mapGen = GameMaze(width: 32, height: 32)
    
    var maxSpeed = 0.1
    let steerDeadZone = CGFloat(0.15)
    
    var timerLabel : SKLabelNode!
    
    var points: Int = 0
    var win = true
    var levelCounter: Int
    var help = true
    
    var timeStart = 0.0
    var timeLimit = 30
    var timeDuration  = 0.0
    var timeInSeconds = 0
    
    var maps = [String]()
    
    let ay = Vector3(x: 0.63, y: 0.0, z: -0.92)
    let az = Vector3(x: 0.0, y: 1.0, z: 0.0)
    let ax = Vector3.crossProduct(Vector3(x: 0.0, y: 1.0, z: 0.0),
        right: Vector3(x: 0.63, y: 0.0, z: -0.92)).normalized()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(size: CGSize, levelCounter: Int) {
        self.levelCounter = levelCounter
        super.init(size: size)
    }
    
    //few methods called when view is shown
    override func didMoveToView(view: SKView) {
        maps = self.mapGen.generateMaze()
        userInteractionEnabled = true //enable to receiver taps on screen
        createWorld()
        createPlayer()
        createHUD()
        centerViewOn(player.position)
        //runAction(SKAction.playSoundFileNamed("minnion_background.mp3", waitForCompletion: false))
    }
    

    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch
    }

   
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        //mapZoom()
    }
    
    func mapZoom() {
        if help {
            var scale = SKAction.scaleBy(0.6, duration: 0.1)
            self.worldNode.runAction(scale)
        }
        self.help = false
        self.zoomMap.hidden = true

    }
    
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //centerViewOn(player.position)
        
        if timeStart == 0.0 {
            timeStart = currentTime
        }
        timeDuration = currentTime - timeStart
        
        timeInSeconds = Int(timeDuration) % 60
        timeInSeconds = timeLimit - timeInSeconds
        self.timerLabel.text = "Time Remaining: \(timeInSeconds)"
        
        checkWin()
        //functipn to move player
        if (win) {
            movePlayerWithAccerlerometer()
        }
    }
    
    //method to move player
    //takes 3d postion and what angle the phone is held at
    //and changes it to 2d
    //up and down motion is not needed of the 3d motion
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
    
    //keeps sprite in center of screen
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
        
        levelCounter++
        
        var ranNum = Int(arc4random_uniform(5) + 1)
        
        switch ranNum {
        case 1:
            return TileMapLayer(atlasName: "scenery", tileSize: CGSize(width: 32, height: 32), tileCodes: map1)
        case 2:
            return TileMapLayer(atlasName: "scenery", tileSize: CGSize(width: 32, height: 32), tileCodes: map2)
        case 3:
            return TileMapLayer(atlasName: "scenery", tileSize: CGSize(width: 32, height: 32), tileCodes: map3)
        case 4:
            return TileMapLayer(atlasName: "scenery", tileSize: CGSize(width: 32, height: 32), tileCodes: map4)
        case 5:
            return TileMapLayer(atlasName: "scenery", tileSize: CGSize(width: 32, height: 32), tileCodes: map5)
        case 6:
            return TileMapLayer(atlasName: "scenery", tileSize: CGSize(width: 32, height: 32), tileCodes: map6)
        default:
            return TileMapLayer(atlasName: "scenery", tileSize: CGSize(width: 32, height: 32), tileCodes: map1)
        }
    }
    
    func createWorld() {
        
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates()
        
        backGroundLayer = createScenery()
        
        worldNode = SKNode()
        worldNode.addChild(backGroundLayer)
        addChild(worldNode!)
        
        var levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "Level: \(levelCounter)"
        levelLabel.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        levelLabel.horizontalAlignmentMode = .Center
        levelLabel.fontColor = SKColor.whiteColor()
        levelLabel.fontSize = 40
        worldNode.addChild(levelLabel)
        
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
            physicsWorld.contactDelegate = self
        
        
        //action for level
        
        let levelZoom = SKAction.scaleBy(1.2, duration: 0.5)
        let levelDisap = SKAction.fadeOutWithDuration(0.5)
        let actionLevel = SKAction.sequence([levelZoom, levelDisap])
        levelLabel.runAction(actionLevel)
    }
    
    func createPlayer() {
        
        player = Player()
        player.setScale(1)
        player.zPosition = 50
        player.position = CGPoint(x: 50, y: 50)
        worldNode.addChild(player)
    }
    
    func createHUD() {
        
        timerLabel = SKLabelNode(fontNamed: "Chalkduster")
        timerLabel.fontSize = 18
        timerLabel.horizontalAlignmentMode = .Left
        timerLabel.text = "Time: \(timeLimit)"
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            // different placement on iPad
            timerLabel.position = CGPoint(x: 200, y: size.height / 2 - 60)
        } else {
            timerLabel.position = CGPoint(x: 0, y: size.height / 2 - 30)
        }
        timerLabel.zPosition = 100
        addChild(timerLabel)
        
        //powerup option
        zoomMap = SKSpriteNode(imageNamed: "map")
        zoomMap.alpha = 2.0
        zoomMap.zPosition = 50
        zoomMap.position = CGPoint(x: -200, y: 150)
        //addChild(zoomMap)

    }
    
     func didBeginContact(contact: SKPhysicsContact) {
        let other = (contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA)
        
        switch other.categoryBitMask {
        case PhysicsCategory.Banana :
            let getPoint = other.node as Banana
            getPoint.getBanana()
            increaseSeconds(5)
        case PhysicsCategory.Water :
            win = true
            gameOverScreen(win)
        default:
            break;
        }
        
    }
    
    func checkWin() {
        if self.timeInSeconds == 0 {
            timerLabel.removeFromParent()
            timeInSeconds = 0
            win = false
            player.playerLoose(win)
            //motionManager.stopAccelerometerUpdates()
            gameOverScreen(win)
        }
    }
    
    func gameOverScreen(score: Bool) {
        //backgroundMusicPlayer.stop()
        let gameOverScene = GameOver(size: size, won: win, level: levelCounter)
        gameOverScene.scaleMode = scaleMode
        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        view?.presentScene(gameOverScene, transition: reveal)
    }
    
    func increaseSeconds(increment: Int) {
        timeLimit += increment
    }
}
