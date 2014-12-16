//
//  GameViewController.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 13/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        
            super.viewDidLoad()
            let scene = StartScreen(size: view.bounds.size)
            let skView = view as SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .ResizeFill
            skView.presentScene(scene)
    }
    
    
    func gameOverWithWin(didWin: Bool) {
        
        let alert = UIAlertController(title: didWin ? "You won!": "You lost", message: "Game Over", preferredStyle: .Alert)
        presentViewController(alert, animated: true, completion: nil)
        
        let delayInSeconds = 3.0
        let popTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(delayInSeconds) * Int64(NSEC_PER_SEC))
        
        dispatch_after(popTime, dispatch_get_main_queue(),  {
            self.goBack(alert)
        })
        
    }
    
    func goBack(alert: UIAlertController) {
        alert.dismissViewControllerAnimated(true, completion: {
            self.navigationController!.popToRootViewControllerAnimated(false)
            return
        })
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
