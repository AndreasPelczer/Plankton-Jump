//
//  TitleView.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SwiftUI

struct TitleView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ZStack {
            Color.cyan.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("Plankton Jump")
                    .font(.system(size: 42, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(radius: 5)

                Text("High Score: \(viewModel.highScore)")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))

                Button(action: {
                    viewModel.startGame()
                }) {
                    Text("Start")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
            }
        }
    }
}
