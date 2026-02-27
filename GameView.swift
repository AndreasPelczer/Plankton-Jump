//
//  GameView.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// GameView.swift
// PlanktonJump - Kassenband Runner
// View/Screen: SpriteKit-Wrapper für SwiftUI

import SwiftUI
import SpriteKit

struct GameView: View {
    
    let onGameOver: (_ score: Int, _ yummies: Int, _ highScore: Int) -> Void
    
    @State private var scene: GameScene = {
        let scene = GameScene(size: CGSize(width: GameConfig.sceneWidth,
                                           height: GameConfig.sceneHeight))
        scene.scaleMode = .aspectFill
        return scene
    }()
    
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
            .onReceive(
                NotificationCenter.default.publisher(for: .planktonGameOver)
            ) { notification in
                if let info = notification.userInfo {
                    let score = info["score"] as? Int ?? 0
                    let yummies = info["yummies"] as? Int ?? 0
                    let highScore = info["highScore"] as? Int ?? 0
                    onGameOver(score, yummies, highScore)
                }
            }
    }
}