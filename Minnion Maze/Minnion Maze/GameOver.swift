//
//  GameOver.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 15/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//

import Foundation
import SpriteKit

class GameOver: SKScene {

    var won: Bool
    var score: Int
    
    init(size: CGSize, won: Bool, score: Int) {
        self.won = won
        self.score = score
        super.init(size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        
        self.backgroundColor  = UIColor(red: 169/255, green: 249/255, blue: 252/255, alpha: 1.0)
        
        var winLooseImage: SKSpriteNode
        
        if (won) {
            winLooseImage = SKSpriteNode(imageNamed: "youWinMinnion")
        } else {
            winLooseImage = SKSpriteNode(imageNamed: "youLoseMinnion")
        }
        
        winLooseImage.position = CGPointMake(self.frame.width / 2, self.frame.size.height / 2)
        self.addChild(winLooseImage)
        
        var scoreBoard = SKLabelNode(fontNamed: "Chalkduster")
        scoreBoard.text = "Your Score: " + String(score)
        scoreBoard.position = CGPointMake(self.frame.width / 2, winLooseImage.position.y - 100)
        scoreBoard.horizontalAlignmentMode = .Center
        scoreBoard.fontColor = SKColor.blueColor()
        scoreBoard.fontSize = 40
        addChild(scoreBoard)
        
        //winLooseImage.runAction(SKAction.scaleBy(1.2, duration: 2))
        var scoreAction = SKAction.sequence([SKAction.scaleBy(0.8, duration: 0.5), SKAction.scaleBy( 1.2, duration: 0.5)])
        winLooseImage.runAction(SKAction.sequence([scoreAction, scoreAction, scoreAction]))
        
        let wait = SKAction.waitForDuration(5.0)
        let block = SKAction.runBlock {
            let myScene = StartScreen(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.runAction(SKAction.sequence([wait, block]))
    }
}