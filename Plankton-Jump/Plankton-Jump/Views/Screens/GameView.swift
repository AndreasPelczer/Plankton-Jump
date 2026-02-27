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

    var scene: GameScene {
        let scene = GameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        scene.viewModel = viewModel
        return scene
    }

    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Text("Score: \(viewModel.score)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
