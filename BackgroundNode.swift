//
//  BackgroundNode.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// BackgroundNode.swift
// PlanktonJump - Kassenband Runner
// View/Node: Hintergrund – Regal, Kassenband, Papiertextur

import SpriteKit

final class BackgroundNode: SKNode {
    
    private let lineColor = UIColor(white: 0.13, alpha: 1)
    private let paperColor = UIColor(red: 0.91, green: 0.89, blue: 0.87, alpha: 1)
    
    // Scrollende Elemente
    private var beltLines: [SKShapeNode] = []
    private var shelfLayer: SKNode!
    private var eyeNodes: [(left: SKShapeNode, right: SKShapeNode, blink: SKShapeNode)] = []
    
    // MARK: - Init
    
    override init() {
        super.init()
        setupBackground()
        setupShelf()
        setupBelt()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // MARK: - Setup
    
    private func setupBackground() {
        // Zerknittertes Papier als Hintergrund
        let bg = SKShapeNode(rectOf: CGSize(width: GameConfig.sceneWidth,
                                            height: GameConfig.sceneHeight))
        bg.fillColor = paperColor
        bg.strokeColor = .clear
        bg.position = CGPoint(x: GameConfig.sceneWidth / 2,
                              y: GameConfig.sceneHeight / 2)
        bg.zPosition = -100
        addChild(bg)
        
        // Papier-Knicke (subtile Linien)
        for _ in 0..<8 {
            let crease = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: CGFloat.random(in: 0...GameConfig.sceneWidth),
                                  y: CGFloat.random(in: 0...GameConfig.sceneHeight)))
            path.addLine(to: CGPoint(x: CGFloat.random(in: 0...GameConfig.sceneWidth),
                                     y: CGFloat.random(in: 0...GameConfig.sceneHeight)))
            crease.path = path
            crease.strokeColor = UIColor(white: 0, alpha: 0.03)
            crease.lineWidth = 1
            crease.zPosition = -99
            addChild(crease)
        }
        
        // Papier-Textur (kleine Punkte)
        for _ in 0..<200 {
            let dot = SKShapeNode(circleOfRadius: CGFloat.random(in: 0.5...1.5))
            dot.position = CGPoint(x: CGFloat.random(in: 0...GameConfig.sceneWidth),
                                   y: CGFloat.random(in: 0...GameConfig.sceneHeight))
            dot.fillColor = UIColor(white: 0, alpha: CGFloat.random(in: 0.01...0.04))
            dot.strokeColor = .clear
            dot.zPosition = -98
            addChild(dot)
        }
    }
    
    // MARK: - Regal
    
    private func setupShelf() {
        shelfLayer = SKNode()
        shelfLayer.zPosition = -50
        addChild(shelfLayer)
        
        let shelfTop = GameConfig.sceneHeight - GameConfig.shelfTopY
        let shelfH: CGFloat = GameConfig.shelfHeight
        
        // Regalbretter (3 Linien)
        for i in 0..<3 {
            let y = shelfTop - CGFloat(i) * (shelfH / 2)
            let line = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: GameConfig.sceneWidth, y: y))
            line.path = path
            line.strokeColor = lineColor
            line.lineWidth = 2.0
            shelfLayer.addChild(line)
        }
        
        // BLA-Pakete auf dem Regal (scrollend, doppelt für Loop)
        let packageGap: CGFloat = 45
        let totalWidth = GameConfig.sceneWidth + packageGap * 2
        
        for set in 0..<2 {  // 2 Sets für nahtloses Scrollen
            let setNode = SKNode()
            setNode.name = "shelfSet_\(set)"
            setNode.position.x = CGFloat(set) * totalWidth
            
            for i in stride(from: CGFloat(0), to: totalWidth, by: packageGap) {
                // Oberes Regal
                let pkg1 = createBLAPackage(small: true)
                pkg1.position = CGPoint(x: i, y: shelfTop - 25)
                setNode.addChild(pkg1)
                
                // Unteres Regal
                let pkg2 = createBLAPackage(small: true)
                pkg2.position = CGPoint(x: i + 20, y: shelfTop - shelfH / 2 - 25)
                setNode.addChild(pkg2)
            }
            
            shelfLayer.addChild(setNode)
        }
        
        // Augen zwischen Paketen
        setupEyes(shelfTop: shelfTop)
    }
    
    private func createBLAPackage(small: Bool) -> SKNode {
        let node = SKNode()
        
        let w: CGFloat = small ? 20 : 30
        let h: CGFloat = small ? 36 : 22
        
        let body = SKShapeNode(rectOf: CGSize(width: w, height: h))
        body.fillColor = UIColor.white
        body.strokeColor = lineColor
        body.lineWidth = 1.5
        node.addChild(body)
        
        let label = SKLabelNode(text: "BLA")
        label.fontName = "Marker Felt"
        label.fontSize = small ? 8 : 12
        label.fontColor = lineColor
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 0, y: 4)
        node.addChild(label)
        
        let sub = SKLabelNode(text: "BLA")
        sub.fontName = "Marker Felt"
        sub.fontSize = small ? 5 : 7
        sub.fontColor = UIColor(white: 0.5, alpha: 1)
        sub.verticalAlignmentMode = .center
        sub.position = CGPoint(x: 0, y: -4)
        node.addChild(sub)
        
        let price = SKLabelNode(text: "9,45€")
        price.fontName = "Marker Felt"
        price.fontSize = small ? 4 : 6
        price.fontColor = lineColor
        price.verticalAlignmentMode = .center
        price.position = CGPoint(x: 0, y: -11)
        node.addChild(price)
        
        return node
    }
    
    // MARK: - Gruselige Augen
    
    private func setupEyes(shelfTop: CGFloat) {
        let eyeY = shelfTop - 25
        
        for x in stride(from: CGFloat(60), to: GameConfig.sceneWidth, by: 120) {
            // Linkes Auge
            let leftEye = SKShapeNode(circleOfRadius: 6)
            leftEye.position = CGPoint(x: x, y: eyeY)
            leftEye.fillColor = .white
            leftEye.strokeColor = lineColor
            leftEye.lineWidth = 1.5
            leftEye.zPosition = -45
            shelfLayer.addChild(leftEye)
            
            let leftPupil = SKShapeNode(circleOfRadius: 3)
            leftPupil.position = CGPoint(x: 1, y: -1)
            leftPupil.fillColor = lineColor
            leftPupil.strokeColor = .clear
            leftEye.addChild(leftPupil)
            
            // Rechtes Auge
            let rightEye = SKShapeNode(circleOfRadius: 6)
            rightEye.position = CGPoint(x: x + 14, y: eyeY)
            rightEye.fillColor = .white
            rightEye.strokeColor = lineColor
            rightEye.lineWidth = 1.5
            rightEye.zPosition = -45
            shelfLayer.addChild(rightEye)
            
            let rightPupil = SKShapeNode(circleOfRadius: 3)
            rightPupil.position = CGPoint(x: 1, y: -1)
            rightPupil.fillColor = lineColor
            rightPupil.strokeColor = .clear
            rightEye.addChild(rightPupil)
            
            // Blink-Strich (versteckt, wird beim Blinzeln gezeigt)
            let blink = SKShapeNode()
            let blinkPath = CGMutablePath()
            blinkPath.move(to: CGPoint(x: x - 5, y: eyeY))
            blinkPath.addLine(to: CGPoint(x: x + 19, y: eyeY))
            blink.path = blinkPath
            blink.strokeColor = lineColor
            blink.lineWidth = 2
            blink.zPosition = -44
            blink.isHidden = true
            shelfLayer.addChild(blink)
            
            eyeNodes.append((left: leftEye, right: rightEye, blink: blink))
            
            // Blinzel-Animation
            let blinkAction = SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.wait(forDuration: Double.random(in: 2...5)),
                    SKAction.run {
                        leftEye.isHidden = true
                        rightEye.isHidden = true
                        blink.isHidden = false
                    },
                    SKAction.wait(forDuration: 0.15),
                    SKAction.run {
                        leftEye.isHidden = false
                        rightEye.isHidden = false
                        blink.isHidden = true
                    }
                ])
            )
            leftEye.run(blinkAction)
        }
    }
    
    // MARK: - Kassenband
    
    private func setupBelt() {
        let beltY = GameConfig.sceneHeight - GameConfig.beltY
        let beltH = GameConfig.beltHeight
        
        // Band-Fläche
        let belt = SKShapeNode(rectOf: CGSize(width: GameConfig.sceneWidth, height: beltH))
        belt.position = CGPoint(x: GameConfig.sceneWidth / 2, y: beltY - beltH / 2)
        belt.fillColor = UIColor(white: 0.87, alpha: 1)
        belt.strokeColor = .clear
        belt.zPosition = -30
        addChild(belt)
        
        // Obere Kante
        let topLine = SKShapeNode()
        let topPath = CGMutablePath()
        topPath.move(to: CGPoint(x: 0, y: beltY))
        topPath.addLine(to: CGPoint(x: GameConfig.sceneWidth, y: beltY))
        topLine.path = topPath
        topLine.strokeColor = lineColor
        topLine.lineWidth = 2.0
        topLine.zPosition = -29
        addChild(topLine)
        
        // Untere Kante
        let bottomLine = SKShapeNode()
        let bottomPath = CGMutablePath()
        bottomPath.move(to: CGPoint(x: 0, y: beltY - beltH))
        bottomPath.addLine(to: CGPoint(x: GameConfig.sceneWidth, y: beltY - beltH))
        bottomLine.path = bottomPath
        bottomLine.strokeColor = lineColor
        bottomLine.lineWidth = 2.0
        bottomLine.zPosition = -29
        addChild(bottomLine)
        
        // Band-Linien (scrollend)
        let lineGap: CGFloat = 20
        for x in stride(from: CGFloat(0), to: GameConfig.sceneWidth + lineGap, by: lineGap) {
            let beltLine = SKShapeNode()
            let path = CGMutablePath()
            path.move(to: CGPoint(x: x, y: beltY - 2))
            path.addLine(to: CGPoint(x: x, y: beltY - beltH + 2))
            beltLine.path = path
            beltLine.strokeColor = UIColor(white: 0.75, alpha: 1)
            beltLine.lineWidth = 1.0
            beltLine.zPosition = -28
            beltLine.name = "beltLine"
            addChild(beltLine)
            beltLines.append(beltLine)
        }
        
        // Rollen
        for rx in [CGFloat(40), GameConfig.sceneWidth - 40] {
            let roller = SKShapeNode(circleOfRadius: 12)
            roller.position = CGPoint(x: rx, y: beltY - beltH - 12)
            roller.fillColor = UIColor(white: 0.6, alpha: 1)
            roller.strokeColor = lineColor
            roller.lineWidth = 2.0
            roller.zPosition = -25
            roller.name = "roller"
            addChild(roller)
            
            // Speichen in der Rolle
            let spoke = SKShapeNode()
            let spokePath = CGMutablePath()
            spokePath.move(to: CGPoint(x: -8, y: 0))
            spokePath.addLine(to: CGPoint(x: 8, y: 0))
            spokePath.move(to: CGPoint(x: 0, y: -8))
            spokePath.addLine(to: CGPoint(x: 0, y: 8))
            spoke.path = spokePath
            spoke.strokeColor = UIColor(white: 0.4, alpha: 1)
            spoke.lineWidth = 1.0
            spoke.name = "spoke"
            roller.addChild(spoke)
        }
    }
    
    // MARK: - Update (Scrolling)
    
    func update(scrollOffset: CGFloat, speed: CGFloat) {
        let lineGap: CGFloat = 20
        
        // Band-Linien scrollen
        for line in beltLines {
            line.position.x -= speed
            if line.position.x < -lineGap {
                line.position.x += CGFloat(beltLines.count) * lineGap
            }
        }
        
        // Regal-Pakete scrollen (parallax, langsamer)
        let shelfSpeed = speed * 0.3
        let totalWidth = GameConfig.sceneWidth + 45 * 2
        
        shelfLayer.enumerateChildNodes(withName: "shelfSet_*") { node, _ in
            node.position.x -= shelfSpeed
            if node.position.x < -totalWidth {
                node.position.x += totalWidth * 2
            }
        }
        
        // Rollen drehen
        enumerateChildNodes(withName: "roller") { node, _ in
            if let spoke = node.childNode(withName: "spoke") {
                spoke.zRotation -= speed * 0.05
            }
        }
    }
}