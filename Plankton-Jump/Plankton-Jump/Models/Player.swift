//
//  Player.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import Foundation

struct Player {
    var position: CGPoint = .zero
    var velocity: CGVector = .zero
    var isJumping: Bool = false
    var isAlive: Bool = true
    var score: Int = 0
}
