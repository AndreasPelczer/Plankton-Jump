//
//  ContentView.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            switch viewModel.gameState {
            case .title:
                TitleView(viewModel: viewModel)
            case .playing:
                GameView(viewModel: viewModel)
            case .gameOver:
                GameOverView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
