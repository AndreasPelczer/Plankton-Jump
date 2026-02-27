//
//  PlanktonNode.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SpriteKit

class PlanktonNode: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "plankton")
        let size = CGSize(width: 50, height: 50)
        super.init(texture: texture, color: .clear, size: size)

        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.collectible | PhysicsCategory.ground
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func jump() {
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: GameConfig.jumpForce))
    }
}

struct PhysicsCategory {
    static let player: UInt32 = 0x1 << 0
    static let obstacle: UInt32 = 0x1 << 1
    static let collectible: UInt32 = 0x1 << 2
    static let ground: UInt32 = 0x1 << 3
}
