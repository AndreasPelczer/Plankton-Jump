//
//  Collectible.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// Collectible.swift
// PlanktonJump - Kassenband Runner
// Model: Reine Daten, kein UI

import Foundation

/// Sammelobjekt auf dem Kassenband
struct Collectible: Identifiable {
    
    let id = UUID()
    
    // MARK: - Types
    
    enum CollectibleType {
        case yummynudeln     // Standard-Sammelobjekt (50 Punkte)
        // Später erweiterbar: goldenGurke, pfandbon, etc.
    }
    
    // MARK: - Properties
    
    let type: CollectibleType
    var position: CGPoint
    var isCollected: Bool = false
    var isActive: Bool = true
    
    /// Punkte für dieses Item
    var points: Int {
        switch type {
        case .yummynudeln: return 50
        }
    }
    
    /// Sammel-Radius
    var collectRadius: CGFloat {
        25
    }
    
    // MARK: - Factory
    
    static func yummynudeln(atX x: CGFloat) -> Collectible {
        Collectible(
            type: .yummynudeln,
            position: CGPoint(x: x, y: Player.groundY - 15)
        )
    }
    
    // MARK: - Update
    
    mutating func update(speed: CGFloat) {
        position.x -= speed
        
        if position.x < -40 {
            isActive = false
        }
    }
    
    /// Prüft ob der Spieler nah genug ist zum Einsammeln
    func canCollect(playerPosition: CGPoint) -> Bool {
        guard !isCollected else { return false }
        let dx = position.x - playerPosition.x
        let dy = position.y - playerPosition.y
        let distance = sqrt(dx * dx + dy * dy)
        return distance < collectRadius
    }
}