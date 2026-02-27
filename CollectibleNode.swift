//
//  CollectibleNode.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// CollectibleNode.swift
// PlanktonJump - Kassenband Runner
// View/Node: Zeichnet Yummynudeln im Skizzenstil

import SpriteKit

final class CollectibleNode: SKNode {
    
    private let lineColor = UIColor(white: 0.13, alpha: 1)
    private let fillColor = UIColor.white
    
    // MARK: - Init
    
    override init() {
        super.init()
        setupYummynudeln()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // MARK: - Setup
    
    private func setupYummynudeln() {
        // Packung
        let body = SKShapeNode(rectOf: CGSize(width: 24, height: 18), cornerRadius: 1)
        body.fillColor = fillColor
        body.strokeColor = lineColor
        body.lineWidth = 1.5
        addChild(body)
        
        // "YUMMY" Text
        let label = SKLabelNode(text: "YUMMY")
        label.fontName = "Marker Felt"
        label.fontSize = 6
        label.fontColor = lineColor
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 3)
        addChild(label)
        
        // "NUDELN" Text
        let sub = SKLabelNode(text: "NUDELN")
        sub.fontName = "Marker Felt"
        sub.fontSize = 5
        sub.fontColor = lineColor
        sub.verticalAlignmentMode = .center
        sub.position = CGPoint(x: 0, y: -4)
        addChild(sub)
        
        // Preis
        let price = SKLabelNode(text: "0,49€")
        price.fontName = "Marker Felt"
        price.fontSize = 5
        price.fontColor = UIColor(white: 0.5, alpha: 1)
        price.verticalAlignmentMode = .center
        price.position = CGPoint(x: 0, y: -10)
        addChild(price)
        
        // Funkeln-Animation
        addSparkle()
        
        // Leichtes Schweben
        let bob = SKAction.sequence([
            SKAction.moveBy(x: 0, y: 4, duration: 0.5),
            SKAction.moveBy(x: 0, y: -4, duration: 0.5)
        ])
        run(SKAction.repeatForever(bob))
    }
    
    private func addSparkle() {
        // Kleines Sternchen das blinkt
        let sparkle = SKShapeNode()
        let path = CGMutablePath()
        // Kreuz-Stern
        path.move(to: CGPoint(x: 14, y: 10))
        path.addLine(to: CGPoint(x: 18, y: 10))
        path.move(to: CGPoint(x: 16, y: 8))
        path.addLine(to: CGPoint(x: 16, y: 12))
        sparkle.path = path
        sparkle.strokeColor = lineColor
        sparkle.lineWidth = 1.0
        addChild(sparkle)
        
        let blink = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.fadeIn(withDuration: 0.3)
        ])
        sparkle.run(SKAction.repeatForever(blink))
    }
    
    // MARK: - Einsammel-Animation
    
    func playCollectAnimation(completion: @escaping () -> Void) {
        let group = SKAction.group([
            SKAction.scale(to: 1.5, duration: 0.15),
            SKAction.fadeOut(withDuration: 0.2),
            SKAction.moveBy(x: 0, y: 30, duration: 0.2)
        ])
        run(SKAction.sequence([group, SKAction.run(completion)]))
    }
    
    // MARK: - Update
    
    func update(collectible: Collectible) {
        self.position = CGPoint(x: collectible.position.x,
                                y: GameConfig.sceneHeight - collectible.position.y)
    }
}