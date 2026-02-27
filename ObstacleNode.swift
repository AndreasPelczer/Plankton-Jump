//
//  ObstacleNode.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// ObstacleNode.swift
// PlanktonJump - Kassenband Runner
// View/Node: Zeichnet Hindernisse im Skizzenstil

import SpriteKit

final class ObstacleNode: SKNode {
    
    let obstacleType: Obstacle.ObstacleType
    
    private let lineColor = UIColor(white: 0.13, alpha: 1)
    private let fillColor = UIColor.white
    private let redAccent = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
    
    // MARK: - Init
    
    init(type: Obstacle.ObstacleType) {
        self.obstacleType = type
        super.init()
        
        switch type {
        case .warentrenner:
            setupWarentrenner()
        case .steckdosenleiste:
            setupSteckdosenleiste()
        case .blaPackage:
            setupBLA()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // MARK: - Warentrenner
    
    private func setupWarentrenner() {
        // Körper (flacher Balken)
        let body = SKShapeNode(rectOf: CGSize(width: 50, height: 12), cornerRadius: 2)
        body.fillColor = fillColor
        body.strokeColor = lineColor
        body.lineWidth = 2.0
        addChild(body)
        
        // Label "NÄCHSTER KUNDE"
        let label = SKLabelNode(text: "NÄCHSTER KUNDE")
        label.fontName = "Marker Felt"
        label.fontSize = 6
        label.fontColor = lineColor
        label.verticalAlignmentMode = .center
        addChild(label)
        
        // Griff-Rillen (kleine Linien)
        for x in stride(from: -18, through: 18, by: 6) {
            let line = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: CGFloat(x), y: -4))
            path.addLine(to: CGPoint(x: CGFloat(x), y: 4))
            line.path = path
            line.strokeColor = UIColor(white: 0.7, alpha: 1)
            line.lineWidth = 0.5
            addChild(line)
        }
    }
    
    // MARK: - Steckdosenleiste (einziges rotes Element!)
    
    private func setupSteckdosenleiste() {
        // Roter Glow-Hintergrund
        let glow = SKShapeNode(rectOf: CGSize(width: 56, height: 22))
        glow.fillColor = UIColor(red: 0.85, green: 0.2, blue: 0.2, alpha: 0.12)
        glow.strokeColor = .clear
        addChild(glow)
        
        // Körper (weißer Kasten)
        let body = SKShapeNode(rectOf: CGSize(width: 50, height: 16), cornerRadius: 1)
        body.fillColor = fillColor
        body.strokeColor = lineColor
        body.lineWidth = 2.0
        addChild(body)
        
        // 3 Steckdosen
        for i in -1...1 {
            let socket = SKShapeNode(circleOfRadius: 5)
            socket.position = CGPoint(x: CGFloat(i) * 14, y: 0)
            socket.fillColor = .clear
            socket.strokeColor = lineColor
            socket.lineWidth = 1.5
            addChild(socket)
            
            // Löcher in der Steckdose
            for holeY in [-2, 2] {
                let hole = SKShapeNode(rectOf: CGSize(width: 3, height: 1.5))
                hole.position = CGPoint(x: CGFloat(i) * 14, y: CGFloat(holeY))
                hole.fillColor = lineColor
                hole.strokeColor = .clear
                addChild(hole)
            }
        }
        
        // Roter Schalter
        let switchNode = SKShapeNode(rectOf: CGSize(width: 5, height: 10))
        switchNode.position = CGPoint(x: 20, y: 0)
        switchNode.fillColor = redAccent
        switchNode.strokeColor = lineColor
        switchNode.lineWidth = 1.0
        addChild(switchNode)
        
        // Kabel
        let cable = SKShapeNode()
        let cablePath = CGMutablePath()
        cablePath.move(to: CGPoint(x: -25, y: 0))
        cablePath.addCurve(to: CGPoint(x: -45, y: 8),
                           control1: CGPoint(x: -32, y: 5),
                           control2: CGPoint(x: -38, y: -5))
        cable.path = cablePath
        cable.strokeColor = lineColor
        cable.lineWidth = 2.0
        cable.lineCap = .round
        addChild(cable)
        
        // Funken-Animation
        addSparkEffect()
    }
    
    private func addSparkEffect() {
        let spark = SKShapeNode()
        spark.name = "spark"
        spark.strokeColor = redAccent
        spark.lineWidth = 1.5
        spark.alpha = 0
        addChild(spark)
        
        // Zufällige Funken blinken lassen
        let sparkAction = SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 0.3, withRange: 0.5),
                SKAction.run { [weak self] in
                    self?.updateSpark(spark)
                },
                SKAction.fadeIn(withDuration: 0.05),
                SKAction.wait(forDuration: 0.08),
                SKAction.fadeOut(withDuration: 0.1)
            ])
        )
        spark.run(sparkAction)
    }
    
    private func updateSpark(_ node: SKShapeNode) {
        let path = CGMutablePath()
        for _ in 0..<3 {
            let x = CGFloat.random(in: -25...25)
            let y = CGFloat.random(in: -10...10)
            path.move(to: CGPoint(x: x, y: y))
            path.addLine(to: CGPoint(x: x + CGFloat.random(in: -4...4),
                                     y: y + CGFloat.random(in: -4...4)))
        }
        node.path = path
    }
    
    // MARK: - BLA-Paket
    
    private func setupBLA() {
        // Paket-Körper
        let body = SKShapeNode(rectOf: CGSize(width: 30, height: 22), cornerRadius: 1)
        body.fillColor = fillColor
        body.strokeColor = lineColor
        body.lineWidth = 2.0
        addChild(body)
        
        // "BLA" Text
        let label = SKLabelNode(text: "BLA")
        label.fontName = "Marker Felt"
        label.fontSize = 14
        label.fontColor = lineColor
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 2)
        addChild(label)
        
        // Preis
        let price = SKLabelNode(text: "9,45€")
        price.fontName = "Marker Felt"
        price.fontSize = 6
        price.fontColor = lineColor
        price.verticalAlignmentMode = .center
        price.position = CGPoint(x: 0, y: -7)
        addChild(price)
    }
    
    // MARK: - Update
    
    func update(obstacle: Obstacle) {
        // Position (SpriteKit Y ist invertiert zu unserem Model)
        self.position = CGPoint(x: obstacle.position.x,
                                y: sceneHeight - obstacle.position.y)
        
        if obstacle.type == .blaPackage {
            self.zRotation = obstacle.rotation
        }
    }
    
    /// Scene-Höhe für Y-Konvertierung
    private var sceneHeight: CGFloat {
        GameConfig.sceneHeight
    }
}