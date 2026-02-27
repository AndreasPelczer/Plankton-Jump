//
//  GameOverView.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SwiftUI

struct GameOverView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Text("Game Over")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.red)

                Text("Score: \(viewModel.score)")
                    .font(.title)
                    .foregroundColor(.white)

                Text("High Score: \(viewModel.highScore)")
                    .font(.title2)
                    .foregroundColor(.yellow)

                VStack(spacing: 15) {
                    Button(action: {
                        viewModel.startGame()
                    }) {
                        Text("Retry")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(Color.green)
                            .cornerRadius(12)
                    }

                    Button(action: {
                        viewModel.returnToTitle()
                    }) {
                        Text("Menu")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
            }
        }
    }
}
