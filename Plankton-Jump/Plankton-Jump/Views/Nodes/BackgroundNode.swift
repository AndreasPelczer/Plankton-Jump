//
//  BackgroundNode.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SpriteKit

class BackgroundNode: SKNode {

    func setup(size: CGSize) {
        // Ozean-Hintergrund (Blau-Gradient simuliert)
        let bg = SKSpriteNode(color: UIColor(red: 0.0, green: 0.3, blue: 0.7, alpha: 1.0), size: size)
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.zPosition = -2
        addChild(bg)

        // Hellere obere Hälfte
        let topBg = SKSpriteNode(color: UIColor(red: 0.1, green: 0.5, blue: 0.85, alpha: 0.5), size: CGSize(width: size.width, height: size.height / 2))
        topBg.position = CGPoint(x: size.width / 2, y: size.height * 0.75)
        topBg.zPosition = -1
        addChild(topBg)

        // Blasen-Deko im Hintergrund
        for _ in 0..<8 {
            let bubble = SKShapeNode(circleOfRadius: CGFloat.random(in: 3...8))
            bubble.fillColor = UIColor(white: 1.0, alpha: 0.15)
            bubble.strokeColor = UIColor(white: 1.0, alpha: 0.25)
            bubble.position = CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: GameConfig.groundHeight...size.height)
            )
            bubble.zPosition = -1
            addChild(bubble)
        }

        // Sandboden
        let ground = SKSpriteNode(color: UIColor(red: 0.76, green: 0.65, blue: 0.42, alpha: 1.0), size: CGSize(width: size.width, height: GameConfig.groundHeight))
        ground.position = CGPoint(x: size.width / 2, y: GameConfig.groundHeight / 2)
        ground.zPosition = 0
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        addChild(ground)
    }
}
