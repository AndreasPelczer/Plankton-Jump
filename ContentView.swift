//
//  ContentView.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// ContentView.swift
// PlanktonJump - Kassenband Runner
// View: Haupt-Navigation zwischen Screens

import SwiftUI

struct ContentView: View {
    
    @State private var currentScreen: Screen = .title
    @State private var lastScore: Int = 0
    @State private var lastYummies: Int = 0
    @State private var lastHighScore: Int = 0
    
    enum Screen {
        case title
        case playing
        case gameOver
    }
    
    var body: some View {
        ZStack {
            switch currentScreen {
            case .title:
                TitleView(onStart: {
                    currentScreen = .playing
                })
                .transition(.opacity)
                
            case .playing:
                GameView(onGameOver: { score, yummies, highScore in
                    lastScore = score
                    lastYummies = yummies
                    lastHighScore = highScore
                    withAnimation(.easeIn(duration: 0.3)) {
                        currentScreen = .gameOver
                    }
                })
                .transition(.opacity)
                
            case .gameOver:
                GameOverView(
                    score: lastScore,
                    yummies: lastYummies,
                    highScore: lastHighScore,
                    isNewHighScore: lastScore >= lastHighScore && lastScore > 0,
                    onRestart: {
                        currentScreen = .playing
                    },
                    onTitle: {
                        withAnimation {
                            currentScreen = .title
                        }
                    }
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentScreen)
    }
}

#Preview {
    ContentView()
}