//
//  GameScene.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    weak var viewModel: GameViewModel?

    private var plankton: PlanktonNode!
    private var backgroundNode: BackgroundNode!
    private var lastUpdateTime: TimeInterval = 0
    private var obstacleTimer: TimeInterval = 0
    private var collectibleTimer: TimeInterval = 0

    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: GameConfig.gravity)
        physicsWorld.contactDelegate = self

        backgroundNode = BackgroundNode()
        backgroundNode.setup(size: size)
        addChild(backgroundNode)

        plankton = PlanktonNode()
        plankton.position = CGPoint(x: GameConfig.playerStartX, y: size.height / 2)
        addChild(plankton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        plankton.jump()
    }

    override func update(_ currentTime: TimeInterval) {
        let deltaTime = lastUpdateTime == 0 ? 0 : currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        obstacleTimer += deltaTime
        collectibleTimer += deltaTime

        if obstacleTimer >= GameConfig.obstacleSpawnInterval {
            spawnObstacle()
            obstacleTimer = 0
        }

        if collectibleTimer >= GameConfig.collectibleSpawnInterval {
            spawnCollectible()
            collectibleTimer = 0
        }

        moveNodes(deltaTime: deltaTime)

        if plankton.position.y < 0 {
            viewModel?.endGame()
        }
    }

    private func spawnObstacle() {
        let types: [Obstacle.ObstacleType] = [.rock, .seaweed, .jellyfish]
        let type = types.randomElement()!
        let obstacle = ObstacleNode(type: type)
        obstacle.position = CGPoint(
            x: size.width + 50,
            y: GameConfig.groundHeight + obstacle.size.height / 2
        )
        addChild(obstacle)
    }

    private func spawnCollectible() {
        let types: [Collectible.CollectibleType] = [.bubble, .star]
        let type = types.randomElement()!
        let collectible = CollectibleNode(type: type)
        let yPos = CGFloat.random(in: (GameConfig.groundHeight + 100)...(size.height - 100))
        collectible.position = CGPoint(x: size.width + 50, y: yPos)
        addChild(collectible)
    }

    private func moveNodes(deltaTime: TimeInterval) {
        let moveAmount = CGFloat(deltaTime) * GameConfig.scrollSpeed

        enumerateChildNodes(withName: "//ObstacleNode") { node, _ in
            node.position.x -= moveAmount
            if node.position.x < -50 {
                node.removeFromParent()
            }
        }

        enumerateChildNodes(withName: "//CollectibleNode") { node, _ in
            node.position.x -= moveAmount
            if node.position.x < -50 {
                node.removeFromParent()
            }
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if contactMask == PhysicsCategory.player | PhysicsCategory.obstacle {
            viewModel?.endGame()
        }

        if contactMask == PhysicsCategory.player | PhysicsCategory.collectible {
            let collectibleBody = contact.bodyA.categoryBitMask == PhysicsCategory.collectible
                ? contact.bodyA : contact.bodyB
            if let collectibleNode = collectibleBody.node as? CollectibleNode {
                viewModel?.addScore(collectibleNode.value)
                collectibleNode.removeFromParent()
            }
        }
    }
}
