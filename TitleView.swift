//
//  TitleView.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// TitleView.swift
// PlanktonJump - Kassenband Runner
// View/Screen: Startbildschirm

import SwiftUI

struct TitleView: View {
    
    let onStart: () -> Void
    
    @State private var blinkVisible = true
    @State private var planktonBounce: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Papier-Hintergrund
            Color(red: 0.91, green: 0.89, blue: 0.87)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 80)
                
                // Logo
                VStack(spacing: 4) {
                    Text("PLANKTON")
                        .font(.custom("Marker Felt", size: 48))
                        .foregroundColor(Color(white: 0.13))
                    
                    Text("KASSENBAND RUNNER")
                        .font(.custom("Marker Felt", size: 18))
                        .foregroundColor(Color(white: 0.4))
                    
                    Text("Ein Gurkistan-Spiel")
                        .font(.custom("Marker Felt", size: 13))
                        .foregroundColor(Color(white: 0.6))
                        .padding(.top, 4)
                }
                
                Spacer()
                    .frame(height: 40)
                
                // Plankton Preview (einfache Zeichnung)
                PlanktonPreview()
                    .offset(y: planktonBounce)
                
                Spacer()
                    .frame(height: 30)
                
                // Anleitung
                VStack(spacing: 12) {
                    HStack(spacing: 20) {
                        InstructionBubble(icon: "⬆", text: "TAP\nSpringen")
                        InstructionBubble(icon: "⬇", text: "SWIPE\nDucken")
                    }
                    
                    Text("Springe über Warentrenner\nDucke unter Steckdosenleisten\nSammle Yummynudeln!")
                        .font(.custom("Marker Felt", size: 13))
                        .foregroundColor(Color(white: 0.4))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                
                Spacer()
                
                // Start-Button (blinkend)
                if blinkVisible {
                    Text("TAP TO START")
                        .font(.custom("Marker Felt", size: 22))
                        .foregroundColor(Color(white: 0.13))
                }
                
                Spacer()
                    .frame(height: 30)
                
                // Credits
                Text("© 2026 B.I.N.D.A. Verlag")
                    .font(.custom("Marker Felt", size: 10))
                    .foregroundColor(Color(white: 0.7))
                Text("Gurkistan Gaming Division")
                    .font(.custom("Marker Felt", size: 10))
                    .foregroundColor(Color(white: 0.7))
                
                Spacer()
                    .frame(height: 40)
            }
        }
        .onTapGesture {
            onStart()
        }
        .onAppear {
            // Blink-Animation
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
                blinkVisible.toggle()
            }
            // Plankton hüpft
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                planktonBounce = -10
            }
        }
    }
}

// MARK: - Anleitung-Bubble

private struct InstructionBubble: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 6) {
            Text(icon)
                .font(.system(size: 28))
            Text(text)
                .font(.custom("Marker Felt", size: 11))
                .foregroundColor(Color(white: 0.4))
                .multilineTextAlignment(.center)
        }
        .frame(width: 90, height: 80)
        .background(Color.white.opacity(0.6))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color(white: 0.13), lineWidth: 1.5)
        )
    }
}

// MARK: - Plankton Vorschau (reine SwiftUI Zeichnung)

private struct PlanktonPreview: View {
    var body: some View {
        Canvas { context, size in
            let cx = size.width / 2
            let cy = size.height / 2
            
            // Body
            let bodyRect = CGRect(x: cx - 20, y: cy - 32, width: 40, height: 64)
            context.stroke(
                Path(ellipseIn: bodyRect),
                with: .color(Color(white: 0.13)),
                lineWidth: 3
            )
            context.fill(
                Path(ellipseIn: bodyRect),
                with: .color(.white)
            )
            context.stroke(
                Path(ellipseIn: bodyRect),
                with: .color(Color(white: 0.13)),
                lineWidth: 3
            )
            
            // Auge
            let eyeRect = CGRect(x: cx - 12, y: cy - 16, width: 24, height: 24)
            context.fill(
                Path(ellipseIn: eyeRect),
                with: .color(.white)
            )
            context.stroke(
                Path(ellipseIn: eyeRect),
                with: .color(Color(white: 0.13)),
                lineWidth: 2.5
            )
            
            // Pupille
            let pupilRect = CGRect(x: cx - 2, y: cy - 9, width: 12, height: 12)
            context.fill(
                Path(ellipseIn: pupilRect),
                with: .color(Color(white: 0.13))
            )
            
            // Glanz
            let shineRect = CGRect(x: cx + 4, y: cy - 8, width: 4, height: 4)
            context.fill(
                Path(ellipseIn: shineRect),
                with: .color(.white)
            )
            
            // Haare
            for i in -2...2 {
                let hx = cx + CGFloat(i) * 4
                var path = Path()
                path.move(to: CGPoint(x: hx, y: cy - 32))
                path.addLine(to: CGPoint(x: hx, y: cy - 42 - CGFloat(abs(i)) * 3))
                context.stroke(path, with: .color(Color(white: 0.13)), lineWidth: 2)
            }
            
            // Krone
            var crown = Path()
            crown.move(to: CGPoint(x: cx - 10, y: cy - 32))
            crown.addLine(to: CGPoint(x: cx - 10, y: cy - 38))
            crown.addLine(to: CGPoint(x: cx - 5, y: cy - 35))
            crown.addLine(to: CGPoint(x: cx, y: cy - 42))
            crown.addLine(to: CGPoint(x: cx + 5, y: cy - 35))
            crown.addLine(to: CGPoint(x: cx + 10, y: cy - 38))
            crown.addLine(to: CGPoint(x: cx + 10, y: cy - 32))
            crown.closeSubpath()
            context.fill(crown, with: .color(.yellow))
            context.stroke(crown, with: .color(Color(white: 0.13)), lineWidth: 1.5)
            
            // Mund
            var mouth = Path()
            mouth.move(to: CGPoint(x: cx - 5, y: cy + 12))
            mouth.addQuadCurve(to: CGPoint(x: cx + 5, y: cy + 12),
                               control: CGPoint(x: cx, y: cy + 17))
            context.stroke(mouth, with: .color(Color(white: 0.13)), lineWidth: 2)
        }
        .frame(width: 100, height: 120)
    }
}

#Preview {
    TitleView(onStart: {})
}