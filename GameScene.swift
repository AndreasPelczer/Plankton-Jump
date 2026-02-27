//
//  GameScene.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// GameScene.swift
// PlanktonJump - Kassenband Runner
// View/Scene: Hauptszene – verbindet ViewModel mit Nodes

import SpriteKit

final class GameScene: SKScene {
    
    // MARK: - ViewModel
    
    private let viewModel = GameViewModel()
    
    // MARK: - Nodes
    
    private var backgroundNode: BackgroundNode!
    private var planktonNode: PlanktonNode!
    private var obstacleNodes: [UUID: ObstacleNode] = [:]
    private var collectibleNodes: [UUID: CollectibleNode] = [:]
    
    // MARK: - UI Nodes
    
    private var scoreLabel: SKLabelNode!
    private var yummyLabel: SKLabelNode!
    private var highScoreLabel: SKLabelNode!
    private var warningNode: SKLabelNode?
    
    // MARK: - Touch Tracking
    
    private var touchStartY: CGFloat = 0
    
    // MARK: - Lifecycle
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.91, green: 0.89, blue: 0.87, alpha: 1)
        
        setupBackground()
        setupPlankton()
        setupHUD()
        setupCallbacks()
        
        viewModel.startGame()
    }
    
    // MARK: - Setup
    
    private func setupBackground() {
        backgroundNode = BackgroundNode()
        backgroundNode.zPosition = -100
        addChild(backgroundNode)
    }
    
    private func setupPlankton() {
        planktonNode = PlanktonNode()
        planktonNode.zPosition = 10
        updatePlanktonPosition()
        addChild(planktonNode)
    }
    
    private func setupHUD() {
        // Score
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontName = "Marker Felt"
        scoreLabel.fontSize = 28
        scoreLabel.fontColor = UIColor(white: 0.13, alpha: 1)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 20, y: size.height - 80)
        scoreLabel.zPosition = 100
        addChild(scoreLabel)
        
        let scoreTitleLabel = SKLabelNode(text: "SCORE")
        scoreTitleLabel.fontName = "Marker Felt"
        scoreTitleLabel.fontSize = 14
        scoreTitleLabel.fontColor = UIColor(white: 0.5, alpha: 1)
        scoreTitleLabel.horizontalAlignmentMode = .left
        scoreTitleLabel.position = CGPoint(x: 20, y: size.height - 55)
        scoreTitleLabel.zPosition = 100
        addChild(scoreTitleLabel)
        
        // Yummies
        yummyLabel = SKLabelNode(text: "🍜 0")
        yummyLabel.fontName = "Marker Felt"
        yummyLabel.fontSize = 22
        yummyLabel.fontColor = UIColor(white: 0.13, alpha: 1)
        yummyLabel.horizontalAlignmentMode = .center
        yummyLabel.position = CGPoint(x: size.width / 2, y: size.height - 80)
        yummyLabel.zPosition = 100
        addChild(yummyLabel)
        
        // Highscore
        highScoreLabel = SKLabelNode(text: "BEST: \(viewModel.highScore)")
        highScoreLabel.fontName = "Marker Felt"
        highScoreLabel.fontSize = 16
        highScoreLabel.fontColor = UIColor(white: 0.5, alpha: 1)
        highScoreLabel.horizontalAlignmentMode = .right
        highScoreLabel.position = CGPoint(x: size.width - 20, y: size.height - 70)
        highScoreLabel.zPosition = 100
        addChild(highScoreLabel)
    }
    
    private func setupCallbacks() {
        viewModel.onJump = { [weak self] in
            self?.playJumpSound()
        }
        
        viewModel.onDuck = { [weak self] in
            self?.playDuckSound()
        }
        
        viewModel.onCollect = { [weak self] in
            self?.playCollectSound()
        }
        
        viewModel.onHit = { [weak self] in
            self?.playHitEffect()
        }
        
        viewModel.onBlaWarning = { [weak self] x in
            self?.showBlaWarning(atX: x)
        }
    }
    
    // MARK: - Input
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        touchStartY = touch.location(in: self).y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let endY = touch.location(in: self).y
        let deltaY = endY - touchStartY
        
        if viewModel.gameState == .gameOver {
            // Nach Game Over: Tap → zurück zum Titel
            showGameOver()
            return
        }
        
        // Swipe down = Ducken (in SpriteKit: Y nach unten = kleiner)
        if deltaY < -40 {
            viewModel.duckPressed()
        } else {
            // Tap oder Swipe up = Springen
            viewModel.jumpPressed()
        }
    }
    
    // MARK: - Game Loop
    
    override func update(_ currentTime: TimeInterval) {
        guard viewModel.gameState == .playing else { return }
        
        let dt: TimeInterval = 1.0 / 60.0
        
        // 1. ViewModel updaten (Spiellogik)
        viewModel.update(deltaTime: dt)
        
        // 2. Plankton-Node updaten
        planktonNode.update(player: viewModel.player, deltaTime: dt)
        updatePlanktonPosition()
        
        // 3. Hintergrund scrollen
        backgroundNode.update(scrollOffset: viewModel.scrollOffset,
                              speed: viewModel.speed)
        
        // 4. Obstacle-Nodes synchronisieren
        syncObstacleNodes()
        
        // 5. Collectible-Nodes synchronisieren
        syncCollectibleNodes()
        
        // 6. HUD updaten
        updateHUD()
    }
    
    // MARK: - Position Helpers
    
    /// Konvertiert Model-Y (oben=0) zu SpriteKit-Y (unten=0)
    private func modelToScene(y: CGFloat) -> CGFloat {
        size.height - y
    }
    
    private func updatePlanktonPosition() {
        planktonNode.position = CGPoint(
            x: viewModel.player.position.x,
            y: modelToScene(y: viewModel.player.position.y)
        )
    }
    
    // MARK: - Node Sync
    
    private func syncObstacleNodes() {
        // Aktive Obstacle-IDs
        let activeIDs = Set(viewModel.obstacles.map { $0.id })
        
        // Entfernte Nodes löschen
        for (id, node) in obstacleNodes {
            if !activeIDs.contains(id) {
                node.removeFromParent()
                obstacleNodes.removeValue(forKey: id)
            }
        }
        
        // Neue Nodes erstellen, bestehende updaten
        for obstacle in viewModel.obstacles {
            if let node = obstacleNodes[obstacle.id] {
                // Update Position
                node.position = CGPoint(x: obstacle.position.x,
                                        y: modelToScene(y: obstacle.position.y))
                if obstacle.type == .blaPackage {
                    node.zRotation = obstacle.rotation
                }
            } else {
                // Neuer Node
                let node = ObstacleNode(type: obstacle.type)
                node.position = CGPoint(x: obstacle.position.x,
                                        y: modelToScene(y: obstacle.position.y))
                node.zPosition = 5
                addChild(node)
                obstacleNodes[obstacle.id] = node
            }
        }
    }
    
    private func syncCollectibleNodes() {
        let activeIDs = Set(viewModel.collectibles.filter { !$0.isCollected }.map { $0.id })
        
        // Entfernte/eingesammelte Nodes animiert entfernen
        for (id, node) in collectibleNodes {
            if !activeIDs.contains(id) {
                if node.parent != nil {
                    node.playCollectAnimation {
                        node.removeFromParent()
                    }
                }
                collectibleNodes.removeValue(forKey: id)
            }
        }
        
        // Neue Nodes erstellen, bestehende updaten
        for collectible in viewModel.collectibles where !collectible.isCollected {
            if let node = collectibleNodes[collectible.id] {
                node.position = CGPoint(x: collectible.position.x,
                                        y: modelToScene(y: collectible.position.y))
            } else {
                let node = CollectibleNode()
                node.position = CGPoint(x: collectible.position.x,
                                        y: modelToScene(y: collectible.position.y))
                node.zPosition = 5
                addChild(node)
                collectibleNodes[collectible.id] = node
            }
        }
    }
    
    // MARK: - HUD
    
    private func updateHUD() {
        scoreLabel.text = "\(viewModel.score)"
        yummyLabel.text = "🍜 \(viewModel.yummies)"
        highScoreLabel.text = "BEST: \(viewModel.highScore)"
    }
    
    // MARK: - Sound Effects
    
    private func playJumpSound() {
        run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
        // Fallback: wenn keine Datei vorhanden, sieht man trotzdem die Animation
    }
    
    private func playDuckSound() {
        run(SKAction.playSoundFileNamed("duck.wav", waitForCompletion: false))
    }
    
    private func playCollectSound() {
        run(SKAction.playSoundFileNamed("collect.wav", waitForCompletion: false))
        
        // Visueller Effekt: Score-Pop
        let pop = SKLabelNode(text: "+50")
        pop.fontName = "Marker Felt"
        pop.fontSize = 18
        pop.fontColor = UIColor(white: 0.13, alpha: 1)
        pop.position = CGPoint(x: viewModel.player.position.x + 20,
                               y: modelToScene(y: viewModel.player.position.y) + 30)
        pop.zPosition = 50
        addChild(pop)
        
        let popAction = SKAction.sequence([
            SKAction.group([
                SKAction.moveBy(x: 0, y: 40, duration: 0.5),
                SKAction.fadeOut(withDuration: 0.5)
            ]),
            SKAction.removeFromParent()
        ])
        pop.run(popAction)
    }
    
    private func playHitEffect() {
        run(SKAction.playSoundFileNamed("hit.wav", waitForCompletion: false))
        
        // Screen shake
        let shake = SKAction.sequence([
            SKAction.moveBy(x: 8, y: 0, duration: 0.03),
            SKAction.moveBy(x: -16, y: 0, duration: 0.03),
            SKAction.moveBy(x: 14, y: 0, duration: 0.03),
            SKAction.moveBy(x: -10, y: 0, duration: 0.03),
            SKAction.moveBy(x: 4, y: 0, duration: 0.03),
        ])
        self.scene?.run(shake)
        
        // Flash
        let flash = SKShapeNode(rectOf: size)
        flash.position = CGPoint(x: size.width / 2, y: size.height / 2)
        flash.fillColor = UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 0.3)
        flash.strokeColor = .clear
        flash.zPosition = 200
        addChild(flash)
        flash.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()
        ]))
        
        // Partikel (Skizzen-Zeichen fliegen raus)
        let symbols = ["!", "?", "*", "#", "×", "÷"]
        for _ in 0..<8 {
            let p = SKLabelNode(text: symbols.randomElement()!)
            p.fontName = "Marker Felt"
            p.fontSize = 16
            p.fontColor = UIColor(white: 0.13, alpha: 1)
            p.position = planktonNode.position
            p.zPosition = 50
            addChild(p)
            
            let dx = CGFloat.random(in: -80...80)
            let dy = CGFloat.random(in: 40...120)
            p.run(SKAction.sequence([
                SKAction.group([
                    SKAction.moveBy(x: dx, y: dy, duration: 0.5),
                    SKAction.fadeOut(withDuration: 0.5),
                    SKAction.rotate(byAngle: .pi * 2, duration: 0.5)
                ]),
                SKAction.removeFromParent()
            ]))
        }
        
        // Game Over nach kurzer Verzögerung
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run { [weak self] in
                self?.showGameOver()
            }
        ]))
    }
    
    // MARK: - BLA Warning
    
    private func showBlaWarning(atX x: CGFloat) {
        let warning = SKLabelNode(text: "!")
        warning.fontName = "Marker Felt"
        warning.fontSize = 24
        warning.fontColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
        warning.position = CGPoint(x: x, y: modelToScene(y: GameConfig.shelfTopY + 40))
        warning.zPosition = 50
        addChild(warning)
        
        let blink = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.15),
            SKAction.fadeIn(withDuration: 0.15)
        ])
        warning.run(SKAction.sequence([
            SKAction.repeat(blink, count: 4),
            SKAction.removeFromParent()
        ]))
    }
    
    // MARK: - Game Over
    
    private func showGameOver() {
        guard let view = self.view else { return }
        
        // Benachrichtige die SwiftUI-Seite über NotificationCenter
        NotificationCenter.default.post(
            name: .planktonGameOver,
            object: nil,
            userInfo: [
                "score": viewModel.score,
                "yummies": viewModel.yummies,
                "highScore": viewModel.highScore
            ]
        )
    }
}

// MARK: - Notification Name

extension Notification.Name {
    static let planktonGameOver = Notification.Name("planktonGameOver")
    static let planktonStartGame = Notification.Name("planktonStartGame")
}