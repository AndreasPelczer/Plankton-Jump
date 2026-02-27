//
//  GameOverView.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// GameOverView.swift
// PlanktonJump - Kassenband Runner
// View/Screen: KASSENSCHLUSS!

import SwiftUI

struct GameOverView: View {
    
    let score: Int
    let yummies: Int
    let highScore: Int
    let isNewHighScore: Bool
    let onRestart: () -> Void
    let onTitle: () -> Void
    
    @State private var blinkVisible = true
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Halbtransparenter Papier-Hintergrund
            Color(red: 0.91, green: 0.89, blue: 0.87)
                .opacity(0.92)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Titel
                Text("KASSENSCHLUSS!")
                    .font(.custom("Marker Felt", size: 36))
                    .foregroundColor(Color(white: 0.13))
                    .scaleEffect(showContent ? 1 : 0.5)
                    .opacity(showContent ? 1 : 0)
                
                Text("Die Steckdosenleiste hat gewonnen...")
                    .font(.custom("Marker Felt", size: 14))
                    .foregroundColor(Color(white: 0.5))
                    .padding(.top, 8)
                    .opacity(showContent ? 1 : 0)
                
                Spacer()
                    .frame(height: 50)
                
                // Score-Box
                VStack(spacing: 16) {
                    // Score
                    VStack(spacing: 4) {
                        Text("SCORE")
                            .font(.custom("Marker Felt", size: 14))
                            .foregroundColor(Color(white: 0.5))
                        Text("\(score)")
                            .font(.custom("Marker Felt", size: 44))
                            .foregroundColor(Color(white: 0.13))
                    }
                    
                    // Divider
                    Rectangle()
                        .fill(Color(white: 0.13))
                        .frame(width: 120, height: 1.5)
                    
                    // Yummies
                    HStack {
                        Text("Yummies gesammelt:")
                            .font(.custom("Marker Felt", size: 14))
                            .foregroundColor(Color(white: 0.4))
                        Text("🍜 \(yummies)")
                            .font(.custom("Marker Felt", size: 18))
                            .foregroundColor(Color(white: 0.13))
                    }
                    
                    // Highscore
                    if isNewHighScore {
                        Text("★ NEUER HIGHSCORE! ★")
                            .font(.custom("Marker Felt", size: 18))
                            .foregroundColor(Color(red: 0.8, green: 0.2, blue: 0.2))
                    } else {
                        Text("Highscore: \(highScore)")
                            .font(.custom("Marker Felt", size: 14))
                            .foregroundColor(Color(white: 0.5))
                    }
                }
                .padding(30)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.7))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color(white: 0.13), lineWidth: 2)
                )
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30)
                
                Spacer()
                    .frame(height: 50)
                
                // Buttons
                VStack(spacing: 16) {
                    // Nochmal
                    Button(action: onRestart) {
                        Text("NOCHMAL!")
                            .font(.custom("Marker Felt", size: 22))
                            .foregroundColor(Color(white: 0.13))
                            .frame(width: 200, height: 50)
                            .background(Color.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color(white: 0.13), lineWidth: 2)
                            )
                    }
                    
                    // Zurück zum Titel
                    Button(action: onTitle) {
                        Text("Zurück")
                            .font(.custom("Marker Felt", size: 16))
                            .foregroundColor(Color(white: 0.5))
                    }
                }
                .opacity(showContent ? 1 : 0)
                
                Spacer()
                
                // Dead Plankton
                DeadPlanktonView()
                    .opacity(showContent ? 1 : 0)
                    .padding(.bottom, 60)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
                showContent = true
            }
        }
    }
}

// MARK: - Dead Plankton Zeichnung

private struct DeadPlanktonView: View {
    @State private var wobble: Double = 0
    
    var body: some View {
        Canvas { context, size in
            let cx = size.width / 2
            let cy = size.height / 2
            
            // Body (auf der Seite liegend)
            let bodyRect = CGRect(x: cx - 28, y: cy - 16, width: 56, height: 32)
            context.fill(Path(ellipseIn: bodyRect), with: .color(.white))
            context.stroke(Path(ellipseIn: bodyRect),
                          with: .color(Color(white: 0.13)), lineWidth: 2.5)
            
            // X-Augen
            var xEye = Path()
            // Links
            xEye.move(to: CGPoint(x: cx - 6, y: cy - 6))
            xEye.addLine(to: CGPoint(x: cx - 1, y: cy + 1))
            xEye.move(to: CGPoint(x: cx - 1, y: cy - 6))
            xEye.addLine(to: CGPoint(x: cx - 6, y: cy + 1))
            // Rechts
            xEye.move(to: CGPoint(x: cx + 1, y: cy - 6))
            xEye.addLine(to: CGPoint(x: cx + 6, y: cy + 1))
            xEye.move(to: CGPoint(x: cx + 6, y: cy - 6))
            xEye.addLine(to: CGPoint(x: cx + 1, y: cy + 1))
            context.stroke(xEye, with: .color(Color(white: 0.13)), lineWidth: 2)
            
            // Trauriger Mund
            var mouth = Path()
            mouth.move(to: CGPoint(x: cx - 4, y: cy + 6))
            mouth.addQuadCurve(to: CGPoint(x: cx + 4, y: cy + 6),
                               control: CGPoint(x: cx, y: cy + 2))
            context.stroke(mouth, with: .color(Color(white: 0.13)), lineWidth: 1.5)
            
            // Sternchen (bewusstlos)
            let stars = ["✦", "✧", "✦"]
            for (i, star) in stars.enumerated() {
                let angle = Double(i) * 2.1 + wobble
                let sx = cx + cos(angle) * 24
                let sy = cy - 20 + sin(angle) * 6
                context.draw(
                    Text(star).font(.system(size: 10)).foregroundColor(Color(white: 0.5)),
                    at: CGPoint(x: sx, y: sy)
                )
            }
        }
        .frame(width: 80, height: 50)
        .onAppear {
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                wobble = .pi * 2
            }
        }
    }
}

#Preview {
    GameOverView(
        score: 1234,
        yummies: 7,
        highScore: 2000,
        isNewHighScore: false,
        onRestart: {},
        onTitle: {}
    )
}