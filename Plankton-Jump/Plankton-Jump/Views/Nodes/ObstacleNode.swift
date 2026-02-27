//
//  ObstacleNode.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SpriteKit

class ObstacleNode: SKSpriteNode {

    init(type: Obstacle.ObstacleType) {
        let color: UIColor
        let size: CGSize

        switch type {
        case .rock:
            color = .gray
            size = CGSize(width: 40, height: 40)
        case .seaweed:
            color = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
            size = CGSize(width: 25, height: 60)
        case .jellyfish:
            color = UIColor(red: 0.8, green: 0.2, blue: 0.8, alpha: 0.8)
            size = CGSize(width: 35, height: 45)
        }

        super.init(texture: nil, color: color, size: size)

        self.name = "obstacle"

        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
