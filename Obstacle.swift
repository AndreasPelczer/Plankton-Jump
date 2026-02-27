//
//  Obstacle.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// Obstacle.swift
// PlanktonJump - Kassenband Runner
// Model: Reine Daten, kein UI

import Foundation
internal import CoreGraphics

/// Hindernis auf dem Kassenband
struct Obstacle: Identifiable {
    
    let id = UUID()
    
    // MARK: - Types
    
    enum ObstacleType {
        case warentrenner    // Niedrig → drüberspringen
        case steckdosenleiste // Hoch/fliegend → drunter ducken
        case blaPackage      // Fällt vom Regal → ausweichen
    }
    
    // MARK: - Properties
    
    let type: ObstacleType
    var position: CGPoint
    var velocityY: CGFloat = 0  // Nur für BLA (fällt)
    var rotation: CGFloat = 0   // Für BLA (dreht sich beim Fallen)
    var isActive: Bool = true
    
    // MARK: - Hitbox pro Typ
    
    var hitbox: CGRect {
        switch type {
        case .warentrenner:
            // Flach und breit, liegt auf dem Band
            return CGRect(x: position.x - 25,
                          y: position.y - 6,
                          width: 50,
                          height: 12)
            
        case .steckdosenleiste:
            // Breiter, schwebt in der Luft
            return CGRect(x: position.x - 25,
                          y: position.y - 8,
                          width: 50,
                          height: 16)
            
        case .blaPackage:
            // Quadratisch, fällt
            return CGRect(x: position.x - 15,
                          y: position.y - 12,
                          width: 30,
                          height: 24)
        }
    }
    
    // MARK: - Factory Methods
    
    /// Warentrenner: liegt auf dem Kassenband
    static func warentrenner(atX x: CGFloat) -> Obstacle {
        Obstacle(
            type: .warentrenner,
            position: CGPoint(x: x, y: Player.groundY + 5)
        )
    }
    
    /// Steckdosenleiste: schwebt über dem Band
    static func steckdosenleiste(atX x: CGFloat) -> Obstacle {
        Obstacle(
            type: .steckdosenleiste,
            position: CGPoint(x: x, y: Player.groundY - 35)
        )
    }
    
    /// BLA-Paket: startet oben, fällt runter
    static func blaPackage(atX x: CGFloat, fromY y: CGFloat = 100) -> Obstacle {
        Obstacle(
            type: .blaPackage,
            position: CGPoint(x: x, y: y)
        )
    }
    
    // MARK: - Update
    
    mutating func update(speed: CGFloat, deltaTime: TimeInterval) {
        // Alle bewegen sich nach links (Kassenband)
        position.x -= speed
        
        // BLA fällt zusätzlich nach unten
        if type == .blaPackage {
            velocityY += 0.3  // Schwerkraft
            position.y += velocityY
            rotation += 0.05  // Dreht sich
        }
        
        // Off-screen → deaktivieren
        if position.x < -60 || position.y > Player.groundY + 80 {
            isActive = false
        }
    }
}
