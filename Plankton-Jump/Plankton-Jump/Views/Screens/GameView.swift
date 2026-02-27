//
//  GameView.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var scene: GameScene?

    var body: some View {
        ZStack {
            if let scene = scene {
                SpriteView(scene: scene)
                    .ignoresSafeArea()
            }

            VStack {
                HStack {
                    Text("Score: \(viewModel.score)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .padding()
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            let newScene = GameScene()
            newScene.scaleMode = .resizeFill
            newScene.viewModel = viewModel
            scene = newScene
        }
    }
}
