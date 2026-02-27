//
//  ScoreService.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// ScoreService.swift
// PlanktonJump - Kassenband Runner
// Service: Highscore speichern und laden

import Foundation

struct ScoreService {
    
    private let highScoreKey = "PlanktonJump_HighScore"
    
    func loadHighScore() -> Int {
        UserDefaults.standard.integer(forKey: highScoreKey)
    }
    
    func saveHighScore(_ score: Int) {
        UserDefaults.standard.set(score, forKey: highScoreKey)
    }
    
    func resetHighScore() {
        UserDefaults.standard.removeObject(forKey: highScoreKey)
    }
}