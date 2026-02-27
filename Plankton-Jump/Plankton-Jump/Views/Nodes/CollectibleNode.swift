//
//  CollectibleNode.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SpriteKit

class CollectibleNode: SKSpriteNode {

    let value: Int

    init(type: Collectible.CollectibleType) {
        switch type {
        case .bubble:
            self.value = 1
            let size = CGSize(width: 28, height: 28)
            super.init(texture: nil, color: .clear, size: size)

            let circle = SKShapeNode(circleOfRadius: 14)
            circle.fillColor = UIColor(red: 0.6, green: 0.85, blue: 1.0, alpha: 0.5)
            circle.strokeColor = UIColor(red: 0.8, green: 0.95, blue: 1.0, alpha: 0.9)
            circle.lineWidth = 2
            circle.zPosition = 1
            addChild(circle)

        case .star:
            self.value = 5
            let size = CGSize(width: 30, height: 30)
            super.init(texture: nil, color: .yellow, size: size)
        }

        self.name = "collectible"

        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.collectible
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
