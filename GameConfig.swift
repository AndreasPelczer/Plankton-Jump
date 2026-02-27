//
//  GameConfig.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// GameConfig.swift
// PlanktonJump - Kassenband Runner
// Model: Spielkonstanten und Schwierigkeitseinstellungen

import Foundation

/// Zentrale Konfiguration für das Spiel
struct GameConfig {
    
    // MARK: - Bildschirm (iPhone Portrait)
    
    static let sceneWidth: CGFloat = 750
    static let sceneHeight: CGFloat = 1334
    
    // MARK: - Geschwindigkeit
    
    static let startSpeed: CGFloat = 4.0
    static let maxSpeed: CGFloat = 12.0
    static let speedIncrement: CGFloat = 0.003  // Pro Frame
    
    // MARK: - Spawn-Intervalle (in Frames, ca. 60fps)
    
    static let obstacleSpawnMin: Int = 80
    static let obstacleSpawnMax: Int = 150
    static let collectibleSpawnMin: Int = 100
    static let collectibleSpawnMax: Int = 200
    static let blaSpawnMin: Int = 250
    static let blaSpawnMax: Int = 400
    
    // MARK: - Spawn-Wahrscheinlichkeiten
    
    /// Chance dass Hindernis ein Warentrenner ist (vs. Steckdose)
    static let warentrennerChance: Double = 0.55
    
    /// Chance dass ein BLA-Paket spawnt (bei jedem BLA-Intervall)
    static let blaSpawnChance: Double = 0.6
    
    // MARK: - Punkte
    
    static let pointsPerDistance: Int = 1       // Pro 10 Pixel Distanz
    static let pointsYummy: Int = 50
    static let pointsBonusCombo: Int = 10       // Für späteres Combo-System
    
    // MARK: - Spawn-Position (rechts außerhalb des Bildschirms)
    
    static let spawnX: CGFloat = sceneWidth + 60
    
    // MARK: - Kassenband
    
    static let beltY: CGFloat = Player.groundY + 30
    static let beltHeight: CGFloat = 50
    
    // MARK: - Regal (Hintergrund)
    
    static let shelfTopY: CGFloat = 120
    static let shelfHeight: CGFloat = 180
    
    // MARK: - Game State
    
    enum State {
        case title
        case playing
        case gameOver
    }
}