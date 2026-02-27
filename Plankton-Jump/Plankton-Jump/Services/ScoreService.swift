//
//  ScoreService.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import Foundation

class ScoreService {
    static let shared = ScoreService()

    private let highScoreKey = "highScore"

    private init() {}

    var highScore: Int {
        get { UserDefaults.standard.integer(forKey: highScoreKey) }
        set { UserDefaults.standard.set(newValue, forKey: highScoreKey) }
    }

    func updateHighScore(with score: Int) {
        if score > highScore {
            highScore = score
        }
    }
}
