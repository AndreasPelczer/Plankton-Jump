//
//  Obstacle.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import Foundation

struct Obstacle {
    enum ObstacleType {
        case rock
        case seaweed
        case jellyfish
    }

    var type: ObstacleType
    var position: CGPoint
    var size: CGSize
}
