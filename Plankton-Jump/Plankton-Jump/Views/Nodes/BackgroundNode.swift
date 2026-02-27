//
//  BackgroundNode.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SpriteKit

class BackgroundNode: SKNode {

    func setup(size: CGSize) {
        let background = SKSpriteNode(imageNamed: "ocean_bg")
        background.size = size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)

        let ground = SKSpriteNode(color: .brown, size: CGSize(width: size.width * 2, height: GameConfig.groundHeight))
        ground.position = CGPoint(x: size.width, y: GameConfig.groundHeight / 2)
        ground.zPosition = 0
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        addChild(ground)
    }
}
