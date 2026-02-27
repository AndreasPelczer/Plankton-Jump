//
//  AudioService.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// AudioService.swift
// PlanktonJump - Kassenband Runner
// Service: 8-Bit Sound-Effekte

import AVFoundation

final class AudioService {
    
    static let shared = AudioService()
    
    private init() {
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient, mode: .default)
            try session.setActive(true)
        } catch {
            print("AudioService: Session setup failed - \(error)")
        }
    }
    
    // MARK: - Sound-Effekte (werden in Schritt 3 mit SpriteKit implementiert)
    
    /// Sprung-Sound: Aufsteigender Piep
    func playJump() {
        // TODO: Schritt 3 – SKAction.playSoundFileNamed oder Tone-Generator
    }
    
    /// Duck-Sound: Kurzer tiefer Ton
    func playDuck() {
        // TODO: Schritt 3
    }
    
    /// Sammel-Sound: Fröhliches Pling
    func playCollect() {
        // TODO: Schritt 3
    }
    
    /// Treffer-Sound: Crash
    func playHit() {
        // TODO: Schritt 3
    }
    
    /// BLA-Warnung: Fallgeräusch
    func playBlaWarning() {
        // TODO: Schritt 3
    }
}