//
//  PlanktonJumpApp.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// PlanktonJumpApp.swift
// PlanktonJump - Kassenband Runner
// © 2026 B.I.N.D.A. Verlag – Gurkistan Gaming Division

import SwiftUI

@main
struct PlanktonJumpApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .ignoresSafeArea()
                .preferredColorScheme(.light)
                .statusBarHidden()
        }
    }
}