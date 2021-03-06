//
//  TileMapLayer.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 13/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//

import SpriteKit

class TileMapLayer: SKNode {
    
    let tileSize: CGSize
    var atlas: SKTextureAtlas?
    let gridSize: CGSize
    let layerSize: CGSize
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not Suppoted")
    }
    //initialises with tile size and gride size
    init(tileSize: CGSize, gridSize: CGSize, layerSize: CGSize? = nil) {
            self.tileSize = tileSize
            self.gridSize = gridSize
            if layerSize != nil {
                self.layerSize = layerSize!
            } else {
                self.layerSize =
                    CGSize(width: tileSize.width * gridSize.width,
                        height: tileSize.height * gridSize.height)
            }
        super.init()
    }
    
    
    func nodeForCode(tileCode: Character) -> SKNode? {
        //if not tile images
        if atlas == nil {
            return nil
        }
        
        var tile: SKNode?
        
        switch tileCode {
            
            case "x":
                tile = SKSpriteNode(texture: atlas!.textureNamed("wall"))
            
                if let t = tile as? SKSpriteNode {
                    t.physicsBody = SKPhysicsBody(rectangleOfSize: t.size)
                    t.physicsBody!.categoryBitMask = PhysicsCategory.Wall
                    t.physicsBody!.dynamic = false
                    t.physicsBody!.friction = 0
                }
            
            case "o":
                tile = SKSpriteNode(texture: atlas!.textureNamed("grass1"))
            case "p":
                tile = SKSpriteNode(texture: atlas!.textureNamed("grass1"))
                var potion = SKSpriteNode(texture: atlas!.textureNamed("potion"))
                let scalePotion = SKAction.scaleTo(4, duration: 100)
                potion.runAction(scalePotion)
            
                if let w = tile as? SKSpriteNode {
                    w.physicsBody = SKPhysicsBody(rectangleOfSize: w.size)
                    w.physicsBody!.categoryBitMask = PhysicsCategory.Water
                    w.physicsBody!.collisionBitMask = PhysicsCategory.None
                    w.physicsBody!.contactTestBitMask = PhysicsCategory.Player
                    tile?.addChild(potion)

            }
            case "w":
                tile = SKSpriteNode(texture: atlas!.textureNamed("water1"))
            case "v":
                tile = SKSpriteNode(texture: atlas!.textureNamed("water2"))
            case "=":
                tile = SKSpriteNode(texture: atlas!.textureNamed("grass2"))
            case "b":
                tile = Banana(bananaTexture: atlas!.textureNamed("banana2"),
                    groundTexture: atlas!.textureNamed("grass2"))
            
        default:
            println("Unknown tile code \(tileCode)")
        }
        
        if let sprite = tile as? SKSpriteNode {
            sprite.blendMode = .Replace
            sprite.texture?.filteringMode = .Nearest
        }
        
        return tile
    }
    
    
    convenience init(atlasName: String, tileSize: CGSize, tileCodes: [String]) {
        
        self.init(tileSize: tileSize, gridSize : CGSize(width: countElements(tileCodes[0]),
                                                            height: tileCodes.count))
        
        atlas = SKTextureAtlas(named: atlasName)
        
        for row in 0..<tileCodes.count {
            let line = tileCodes[row]
            for(col, code) in enumerate(line) {
                if let tile = nodeForCode(code)? {
                    tile.position = positionForRow(row, col: col)
                    addChild(tile)
                }
            }
        }
    }
    
    //changes position by calculating size of tile and returning next point
    func positionForRow(row: Int, col: Int) -> CGPoint {
        
        let x = CGFloat(col) * tileSize.width + tileSize.width / 2
        let y = CGFloat(row) * tileSize.height + tileSize.height / 2
        return CGPoint(x: x, y: layerSize.height - y)
    }
}

