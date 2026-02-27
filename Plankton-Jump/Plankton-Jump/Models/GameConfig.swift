//
//  GameConfig.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import Foundation

struct GameConfig {
    static let gravity: CGFloat = -9.8
    static let jumpForce: CGFloat = 500
    static let scrollSpeed: CGFloat = 200
    static let playerStartX: CGFloat = 100
    static let groundHeight: CGFloat = 80
    static let obstacleSpawnInterval: TimeInterval = 2.0
    static let collectibleSpawnInterval: TimeInterval = 3.0
}
