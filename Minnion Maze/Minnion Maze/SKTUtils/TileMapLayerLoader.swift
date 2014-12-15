//
//  TileMapLoader.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 14/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//

import Foundation
import CoreGraphics

func tileMapLayerFromFileNamed(fileName: String) ->  TileMapLayer? {
    // file must be in bundle
    let path = NSBundle.mainBundle().pathForResource(fileName, ofType: nil)
    if path == nil {
        return nil
    }
    
    var error: NSError?
    let fileContents = String(contentsOfFile:path!, encoding: NSUTF8StringEncoding, error: &error)
    
    // if there was an error, there is nothing to be done.
    // Should never happen in properly configured system.
    if error != nil && fileContents == nil {
        return nil
    }
    
    // get the contents of the file, separated into lines
    let lines = Array<String>(fileContents!.componentsSeparatedByString("\n"))
    
    // first line contains the atlas name for this layer's tiles
    let atlasName = lines[0]
    
    // second line contains tile size, in form width x height
    let tileSizeComps = lines[1].componentsSeparatedByString("x")
    
    var width = tileSizeComps[0].toInt()
    
    var height = tileSizeComps[tileSizeComps.endIndex-1].toInt()
    
    if width != nil && height != nil {
        let tileSize = CGSize(width: width!, height: height!)
        
        //  // remaining lines are the grid. It's assumed that all rows are same length
        let tileCodes = lines[2..<lines.endIndex]
        
        return TileMapLayer(atlasName: atlasName, tileSize: tileSize, tileCodes: Array(tileCodes))
    }
    return nil
}
