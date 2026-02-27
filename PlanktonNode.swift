//
//  PlanktonNode.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// PlanktonNode.swift
// PlanktonJump - Kassenband Runner
// View/Node: Zeichnet Plankton im Skizzenstil

import SpriteKit
/Users/andreaspelczer/Documents/Plankton-Jump/Plankton-Jump/Views/Nodes/BackgroundNode.swift
/Users/andreaspelczer/Documents/Plankton-Jump/Plankton-Jump/Views/Nodes/CollectibleNode.swift
/Users/andreaspelczer/Documents/Plankton-Jump/Plankton-Jump/Views/Nodes/ObstacleNode.swift
/Users/andreaspelczer/Documents/Plankton-Jump/Plankton-Jump/Views/Nodes/PlanktonNode.swift
final class PlanktonNode: SKNode {
    
    // MARK: - Child Nodes
    
    private let bodyNode = SKShapeNode()
    private let eyeWhiteNode = SKShapeNode()
    private let pupilNode = SKShapeNode()
    private let eyeShineNode = SKShapeNode()
    private let mouthNode = SKShapeNode()
    private let leftArmNode = SKShapeNode()
    private let rightArmNode = SKShapeNode()
    private let leftLegNode = SKShapeNode()
    private let rightLegNode = SKShapeNode()
    private let crownNode = SKShapeNode()
    private var hairNodes: [SKShapeNode] = []
    
    // MARK: - Animation State
    
    private var animationFrame: CGFloat = 0
    private var currentState: Player.State = .running
    
    // MARK: - Constants
    
    private let lineColor = UIColor(white: 0.13, alpha: 1)
    private let fillColor = UIColor.white
    private let lineWidth: CGFloat = 2.5
    
    // MARK: - Init
    
    override init() {
        super.init()
        setupNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // MARK: - Setup
    
    private func setupNodes() {
        // Body (Gurken-Ellipse)
        let bodyPath = CGMutablePath()
        bodyPath.addEllipse(in: CGRect(x: -14, y: -22, width: 28, height: 44))
        bodyNode.path = bodyPath
        bodyNode.fillColor = fillColor
        bodyNode.strokeColor = lineColor
        bodyNode.lineWidth = lineWidth
        addChild(bodyNode)
        
        // Haare oben (5 Striche)
        for i in -2...2 {
            let hair = SKShapeNode()
            let path = CGMutablePath()
            let x = CGFloat(i) * 3
            path.move(to: CGPoint(x: x, y: 22))
            path.addLine(to: CGPoint(x: x, y: 28 + CGFloat(abs(i)) * 2))
            hair.path = path
            hair.strokeColor = lineColor
            hair.lineWidth = 2.0
            hair.lineCap = .round
            addChild(hair)
            hairNodes.append(hair)
        }
        
        // Auge (groß, einzeln – wie Original-Plankton)
        let eyePath = CGMutablePath()
        eyePath.addEllipse(in: CGRect(x: -9, y: -2, width: 18, height: 18))
        eyeWhiteNode.path = eyePath
        eyeWhiteNode.fillColor = fillColor
        eyeWhiteNode.strokeColor = lineColor
        eyeWhiteNode.lineWidth = 2.0
        addChild(eyeWhiteNode)
        
        // Pupille
        let pupilPath = CGMutablePath()
        pupilPath.addEllipse(in: CGRect(x: -4.5, y: 3, width: 9, height: 9))
        pupilNode.path = pupilPath
        pupilNode.fillColor = lineColor
        pupilNode.strokeColor = .clear
        addChild(pupilNode)
        
        // Glanzpunkt im Auge
        let shinePath = CGMutablePath()
        shinePath.addEllipse(in: CGRect(x: 1, y: 9, width: 3.5, height: 3.5))
        eyeShineNode.path = shinePath
        eyeShineNode.fillColor = fillColor
        eyeShineNode.strokeColor = .clear
        addChild(eyeShineNode)
        
        // Mund (einfacher Strich)
        updateMouth(state: .running)
        addChild(mouthNode)
        
        // Arme
        leftArmNode.strokeColor = lineColor
        leftArmNode.lineWidth = 2.0
        leftArmNode.lineCap = .round
        addChild(leftArmNode)
        
        rightArmNode.strokeColor = lineColor
        rightArmNode.lineWidth = 2.0
        rightArmNode.lineCap = .round
        addChild(rightArmNode)
        
        // Beine
        leftLegNode.strokeColor = lineColor
        leftLegNode.lineWidth = 2.0
        leftLegNode.lineCap = .round
        addChild(leftLegNode)
        
        rightLegNode.strokeColor = lineColor
        rightLegNode.lineWidth = 2.0
        rightLegNode.lineCap = .round
        addChild(rightLegNode)
        
        // Krone (Pla'khuun!)
        let crownPath = CGMutablePath()
        crownPath.move(to: CGPoint(x: -8, y: 22))
        crownPath.addLine(to: CGPoint(x: -8, y: 28))
        crownPath.addLine(to: CGPoint(x: -4, y: 25))
        crownPath.addLine(to: CGPoint(x: 0, y: 30))
        crownPath.addLine(to: CGPoint(x: 4, y: 25))
        crownPath.addLine(to: CGPoint(x: 8, y: 28))
        crownPath.addLine(to: CGPoint(x: 8, y: 22))
        crownPath.closeSubpath()
        crownNode.path = crownPath
        crownNode.fillColor = UIColor(red: 1, green: 0.84, blue: 0, alpha: 1) // Gold
        crownNode.strokeColor = lineColor
        crownNode.lineWidth = 1.5
        addChild(crownNode)
    }
    
    // MARK: - Update (aufgerufen pro Frame)
    
    func update(player: Player, deltaTime: TimeInterval) {
        animationFrame += 1
        
        // Position (SpriteKit: Y ist nach oben!)
        // In SpriteKit setzen wir die Position von außen über die Scene
        
        // State-Change?
        if currentState != player.state {
            currentState = player.state
            onStateChanged(player.state)
        }
        
        // Animationen
        switch player.state {
        case .running:
            animateRunning()
        case .jumping:
            animateJumping()
        case .ducking:
            animateDucking()
        case .dead:
            animateDead()
        }
    }
    
    // MARK: - State Change
    
    private func onStateChanged(_ state: Player.State) {
        updateMouth(state: state)
        
        switch state {
        case .ducking:
            // Body zusammenquetschen
            bodyNode.yScale = 0.6
            bodyNode.position.y = -8
            crownNode.isHidden = true
            hairNodes.forEach { $0.isHidden = true }
            
        case .dead:
            // X-Augen
            updateDeadEyes()
            
        default:
            // Normal
            bodyNode.yScale = 1.0
            bodyNode.position.y = 0
            crownNode.isHidden = false
            hairNodes.forEach { $0.isHidden = false }
        }
    }
    
    // MARK: - Animations
    
    private func animateRunning() {
        let swing = sin(animationFrame * 0.15) * 15
        let bounce = sin(animationFrame * 0.15) * 2
        
        // Leichtes Hüpfen
        bodyNode.position.y = bounce
        crownNode.position.y = bounce
        eyeWhiteNode.position.y = bounce
        pupilNode.position.y = bounce
        eyeShineNode.position.y = bounce
        mouthNode.position.y = bounce
        
        // Arme schwingen
        updateArm(leftArmNode, baseX: -14, swingAngle: swing, side: -1)
        updateArm(rightArmNode, baseX: 14, swingAngle: -swing, side: 1)
        
        // Beine schwingen
        updateLeg(leftLegNode, baseX: -5, swingOffset: swing * 0.5)
        updateLeg(rightLegNode, baseX: 5, swingOffset: -swing * 0.5)
    }
    
    private func animateJumping() {
        // Arme hoch
        let path1 = CGMutablePath()
        path1.move(to: CGPoint(x: -14, y: 2))
        path1.addLine(to: CGPoint(x: -20, y: 16))
        leftArmNode.path = path1
        
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: 14, y: 2))
        path2.addLine(to: CGPoint(x: 20, y: 16))
        rightArmNode.path = path2
        
        // Beine angezogen
        let legPath1 = CGMutablePath()
        legPath1.move(to: CGPoint(x: -5, y: -20))
        legPath1.addLine(to: CGPoint(x: -8, y: -26))
        leftLegNode.path = legPath1
        
        let legPath2 = CGMutablePath()
        legPath2.move(to: CGPoint(x: 5, y: -20))
        legPath2.addLine(to: CGPoint(x: 8, y: -26))
        rightLegNode.path = legPath2
    }
    
    private func animateDucking() {
        // Arme flach
        let path1 = CGMutablePath()
        path1.move(to: CGPoint(x: -14, y: -6))
        path1.addLine(to: CGPoint(x: -22, y: -8))
        leftArmNode.path = path1
        
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: 14, y: -6))
        path2.addLine(to: CGPoint(x: 22, y: -8))
        rightArmNode.path = path2
        
        // Beine weg
        leftLegNode.path = nil
        rightLegNode.path = nil
    }
    
    private func animateDead() {
        let wobble = sin(animationFrame * 0.3) * 5
        self.zRotation = wobble * .pi / 180
    }
    
    // MARK: - Helpers
    
    private func updateArm(_ node: SKShapeNode, baseX: CGFloat, swingAngle: CGFloat, side: CGFloat) {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: baseX, y: 2))
        path.addLine(to: CGPoint(x: baseX + side * 8, y: -8 + swingAngle * 0.3))
        node.path = path
    }
    
    private func updateLeg(_ node: SKShapeNode, baseX: CGFloat, swingOffset: CGFloat) {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: baseX, y: -20))
        path.addLine(to: CGPoint(x: baseX + swingOffset * 0.2, y: -32 - abs(swingOffset * 0.3)))
        // Fuß
        path.addLine(to: CGPoint(x: baseX + swingOffset * 0.2 + 5, y: -33 - abs(swingOffset * 0.3)))
        node.path = path
    }
    
    private func updateMouth(state: Player.State) {
        let path = CGMutablePath()
        switch state {
        case .running:
            // Leichtes Lächeln
            path.move(to: CGPoint(x: -4, y: -10))
            path.addQuadCurve(to: CGPoint(x: 4, y: -10),
                              control: CGPoint(x: 0, y: -13))
        case .jumping:
            // Offener Mund (aufgeregt)
            path.addEllipse(in: CGRect(x: -3, y: -14, width: 6, height: 5))
        case .ducking:
            // Zusammengepresster Mund
            path.move(to: CGPoint(x: -3, y: -10))
            path.addLine(to: CGPoint(x: 3, y: -10))
        case .dead:
            // Trauriger Mund
            path.move(to: CGPoint(x: -4, y: -12))
            path.addQuadCurve(to: CGPoint(x: 4, y: -12),
                              control: CGPoint(x: 0, y: -9))
        }
        mouthNode.path = path
        mouthNode.strokeColor = lineColor
        mouthNode.lineWidth = 1.8
        mouthNode.lineCap = .round
        
        if state == .jumping {
            mouthNode.fillColor = lineColor
        } else {
            mouthNode.fillColor = .clear
        }
    }
    
    private func updateDeadEyes() {
        // X-Augen statt normaler Pupille
        eyeWhiteNode.isHidden = true
        pupilNode.isHidden = true
        eyeShineNode.isHidden = true
        
        let xEye = SKShapeNode()
        let path = CGMutablePath()
        // Linkes X
        path.move(to: CGPoint(x: -6, y: 6))
        path.addLine(to: CGPoint(x: -1, y: 11))
        path.move(to: CGPoint(x: -1, y: 6))
        path.addLine(to: CGPoint(x: -6, y: 11))
        // Rechtes X
        path.move(to: CGPoint(x: 1, y: 6))
        path.addLine(to: CGPoint(x: 6, y: 11))
        path.move(to: CGPoint(x: 6, y: 6))
        path.addLine(to: CGPoint(x: 1, y: 11))
        xEye.path = path
        xEye.strokeColor = lineColor
        xEye.lineWidth = 2.0
        xEye.name = "deadEyes"
        addChild(xEye)
    }
    
    // MARK: - Reset (für neues Spiel)
    
    func reset() {
        currentState = .running
        animationFrame = 0
        self.zRotation = 0
        bodyNode.yScale = 1.0
        bodyNode.position.y = 0
        crownNode.isHidden = false
        hairNodes.forEach { $0.isHidden = false }
        eyeWhiteNode.isHidden = false
        pupilNode.isHidden = false
        eyeShineNode.isHidden = false
        
        // Dead-Eyes entfernen
        childNode(withName: "deadEyes")?.removeFromParent()
        
        updateMouth(state: .running)
    }
}
