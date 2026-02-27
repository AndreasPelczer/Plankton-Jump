//
//  GameViewModel.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SwiftUI
import Combine

enum GameState {
    case title
    case playing
    case gameOver
}

class GameViewModel: ObservableObject {
    @Published var gameState: GameState = .title
    @Published var score: Int = 0
    @Published var highScore: Int = ScoreService.shared.highScore

    func startGame() {
        score = 0
        gameState = .playing
    }

    func endGame() {
        ScoreService.shared.updateHighScore(with: score)
        highScore = ScoreService.shared.highScore
        gameState = .gameOver
    }

    func returnToTitle() {
        gameState = .title
    }

    func addScore(_ points: Int) {
        score += points
    }
}
