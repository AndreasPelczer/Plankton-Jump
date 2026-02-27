//
//  PlanktonNode.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SpriteKit

class PlanktonNode: SKSpriteNode {

    var isOnGround = true

    init() {
        let size = CGSize(width: 40, height: 40)
        super.init(texture: nil, color: .green, size: size)

        self.name = "plankton"

        // Augen
        let leftEye = SKShapeNode(circleOfRadius: 5)
        leftEye.fillColor = .white
        leftEye.strokeColor = .black
        leftEye.position = CGPoint(x: -8, y: 8)
        leftEye.zPosition = 1
        addChild(leftEye)

        let leftPupil = SKShapeNode(circleOfRadius: 2)
        leftPupil.fillColor = .black
        leftPupil.strokeColor = .black
        leftPupil.position = CGPoint(x: 1, y: 0)
        leftEye.addChild(leftPupil)

        let rightEye = SKShapeNode(circleOfRadius: 5)
        rightEye.fillColor = .white
        rightEye.strokeColor = .black
        rightEye.position = CGPoint(x: 8, y: 8)
        rightEye.zPosition = 1
        addChild(rightEye)

        let rightPupil = SKShapeNode(circleOfRadius: 2)
        rightPupil.fillColor = .black
        rightPupil.strokeColor = .black
        rightPupil.position = CGPoint(x: 1, y: 0)
        rightEye.addChild(rightPupil)

        // Mund
        let mouth = SKShapeNode(rectOf: CGSize(width: 12, height: 3), cornerRadius: 1)
        mouth.fillColor = .darkGray
        mouth.strokeColor = .clear
        mouth.position = CGPoint(x: 0, y: -5)
        mouth.zPosition = 1
        addChild(mouth)

        // Antennen
        let leftAntenna = SKShapeNode(rectOf: CGSize(width: 2, height: 12))
        leftAntenna.fillColor = .green
        leftAntenna.strokeColor = .clear
        leftAntenna.position = CGPoint(x: -6, y: 26)
        leftAntenna.zPosition = 1
        addChild(leftAntenna)

        let rightAntenna = SKShapeNode(rectOf: CGSize(width: 2, height: 12))
        rightAntenna.fillColor = .green
        rightAntenna.strokeColor = .clear
        rightAntenna.position = CGPoint(x: 6, y: 26)
        rightAntenna.zPosition = 1
        addChild(rightAntenna)

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
        guard isOnGround else { return }
        isOnGround = false
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
