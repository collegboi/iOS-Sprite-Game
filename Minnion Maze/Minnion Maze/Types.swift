//
//  Types.swift
//  Minnion Maze
//
//  Created by Timothy Barnard on 13/12/2014.
//  Copyright (c) 2014 Timothy Barnard. All rights reserved.
//
// Defines a cateogry for the edge of the world call boundary


struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Boundary  : UInt32 = 0b1       // 1
    static let Player    : UInt32 = 0b10      // 2
    static let Bug       : UInt32 = 0b100     // 4
    static let Wall      : UInt32 = 0b1000    // 8
    static let Water     : UInt32 = 0b10000   // 16
    static let Banana    : UInt32 = 0b100000  // 32
    static let FireBug   : UInt32 = 0b1000000 // 64
}

