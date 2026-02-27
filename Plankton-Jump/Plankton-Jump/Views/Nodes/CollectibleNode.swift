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
        let textureName: String
        let size: CGSize

        switch type {
        case .bubble:
            textureName = "bubble"
            size = CGSize(width: 30, height: 30)
            self.value = 1
        case .star:
            textureName = "star"
            size = CGSize(width: 35, height: 35)
            self.value = 5
        }

        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: .clear, size: size)

        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.collectible
        self.physicsBody?.contactTestBitMask = PhysicsCategory.player
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
