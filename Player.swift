//
//  Player.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// Player.swift
// PlanktonJump - Kassenband Runner
// Model: Reine Daten, kein UI

import Foundation
internal import CoreGraphics

/// Planktons Zustand auf dem Kassenband
struct Player {
    
    // MARK: - States
    
    enum State {
        case running    // Läuft auf dem Kassenband
        case jumping    // In der Luft
        case ducking    // Duckt sich
        case dead       // Getroffen → Game Over
    }
    
    // MARK: - Properties
    
    var position: CGPoint
    var velocityY: CGFloat = 0
    var state: State = .running
    var duckTimer: TimeInterval = 0
    
    // MARK: - Constants
    
    static let groundY: CGFloat = 400
    static let jumpForce: CGFloat = -18
    static let gravity: CGFloat = 0.8
    static let duckDuration: TimeInterval = 0.4
    
    /// Hitbox abhängig vom State
    var hitbox: CGRect {
        switch state {
        case .running, .jumping:
            // Aufrecht: schmaler, höher
            return CGRect(x: position.x - 15,
                          y: position.y - 44,
                          width: 30,
                          height: 55)
        case .ducking:
            // Geduckt: breiter, niedriger
            return CGRect(x: position.x - 18,
                          y: position.y - 15,
                          width: 36,
                          height: 25)
        case .dead:
            return .zero
        }
    }
    
    // MARK: - Init
    
    init(x: CGFloat = 150) {
        self.position = CGPoint(x: x, y: Player.groundY)
    }
    
    // MARK: - Actions
    
    /// Sprung auslösen – gibt true zurück wenn erfolgreich
    mutating func jump() -> Bool {
        guard state == .running else { return false }
        state = .jumping
        velocityY = Player.jumpForce
        return true
    }
    
    /// Ducken auslösen – gibt true zurück wenn erfolgreich
    mutating func duck() -> Bool {
        guard state == .running else { return false }
        state = .ducking
        duckTimer = Player.duckDuration
        return true
    }
    
    /// Physik-Update pro Frame
    mutating func update(deltaTime: TimeInterval) {
        switch state {
        case .jumping:
            velocityY += Player.gravity
            position.y += velocityY
            
            if position.y >= Player.groundY {
                position.y = Player.groundY
                velocityY = 0
                state = .running
            }
            
        case .ducking:
            duckTimer -= deltaTime
            if duckTimer <= 0 {
                state = .running
            }
            
        case .running, .dead:
            break
        }
    }
    
    /// Plankton stirbt
    mutating func die() {
        state = .dead
        velocityY = Player.jumpForce * 0.6
    }
}
