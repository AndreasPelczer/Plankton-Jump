//
//  ObstacleNode.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SpriteKit

class ObstacleNode: SKSpriteNode {

    init(type: Obstacle.ObstacleType) {
        let textureName: String
        let size: CGSize

        switch type {
        case .rock:
            textureName = "rock"
            size = CGSize(width: 40, height: 40)
        case .seaweed:
            textureName = "seaweed"
            size = CGSize(width: 30, height: 60)
        case .jellyfish:
            textureName = "jellyfish"
            size = CGSize(width: 40, height: 50)
        }

        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: .clear, size: size)

        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
