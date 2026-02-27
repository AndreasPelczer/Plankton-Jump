//
//  GameViewModel.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//


// GameViewModel.swift
// PlanktonJump - Kassenband Runner
// ViewModel: Spiellogik, verbindet Model mit View

import Foundation
import Combine
internal import CoreGraphics

final class GameViewModel: ObservableObject {
    
    // MARK: - Published State (Views beobachten diese)
    
    @Published var gameState: GameConfig.State = .title
    @Published var score: Int = 0
    @Published var yummies: Int = 0
    @Published var highScore: Int = 0
    
    // MARK: - Game Objects (Models)
    
    @Published var player = Player()
    @Published var obstacles: [Obstacle] = []
    @Published var collectibles: [Collectible] = []
    
    // MARK: - Internal State
    
    var speed: CGFloat = GameConfig.startSpeed
    var distance: CGFloat = 0
    var scrollOffset: CGFloat = 0
    
    private var obstacleSpawnCounter: Int = 0
    private var obstacleSpawnInterval: Int = GameConfig.obstacleSpawnMin
    
    private var collectibleSpawnCounter: Int = 0
    private var collectibleSpawnInterval: Int = GameConfig.collectibleSpawnMin
    
    private var blaSpawnCounter: Int = 0
    private var blaSpawnInterval: Int = GameConfig.blaSpawnMin
    
    // MARK: - Services
    
    private let scoreService = ScoreService()
    
    // MARK: - Callbacks (für View/Audio-Events)
    
    var onJump: (() -> Void)?
    var onDuck: (() -> Void)?
    var onCollect: (() -> Void)?
    var onHit: (() -> Void)?
    var onBlaWarning: ((CGFloat) -> Void)?  // X-Position des kommenden BLA
    
    // MARK: - Init
    
    init() {
        highScore = scoreService.loadHighScore()
    }
    
    // MARK: - Game State Management
    
    func startGame() {
        // Reset alles
        player = Player()
        obstacles = []
        collectibles = []
        score = 0
        yummies = 0
        speed = GameConfig.startSpeed
        distance = 0
        scrollOffset = 0
        
        // Spawn-Timer zurücksetzen
        obstacleSpawnCounter = 60  // Kurze Gnadenfrist am Start
        obstacleSpawnInterval = randomSpawnInterval(
            minInterval: GameConfig.obstacleSpawnMin,
            maxInterval: GameConfig.obstacleSpawnMax
        )
        collectibleSpawnCounter = 50
        collectibleSpawnInterval = randomSpawnInterval(
            minInterval: GameConfig.collectibleSpawnMin,
            maxInterval: GameConfig.collectibleSpawnMax
        )
        blaSpawnCounter = 200  // BLA kommt erst später
        blaSpawnInterval = randomSpawnInterval(
            minInterval: GameConfig.blaSpawnMin,
            maxInterval: GameConfig.blaSpawnMax
        )
        
        gameState = .playing
    }
    
    func endGame() {
        gameState = .gameOver
        
        if score > highScore {
            highScore = score
            scoreService.saveHighScore(score)
        }
    }
    
    func backToTitle() {
        gameState = .title
    }
    
    // MARK: - Player Input
    
    func jumpPressed() {
        guard gameState == .playing else { return }
        if player.jump() {
            onJump?()
        }
    }
    
    func duckPressed() {
        guard gameState == .playing else { return }
        if player.duck() {
            onDuck?()
        }
    }
    
    // MARK: - Game Loop (aufgerufen von GameScene pro Frame)
    
    func update(deltaTime: TimeInterval) {
        guard gameState == .playing else { return }
        
        // 1. Speed erhöhen
        speed = min(GameConfig.maxSpeed, speed + GameConfig.speedIncrement)
        
        // 2. Distanz & Score
        distance += speed
        scrollOffset += speed
        score = Int(distance / 10) + (yummies * GameConfig.pointsYummy)
        
        // 3. Player updaten
        player.update(deltaTime: deltaTime)
        
        // 4. Obstacles updaten
        updateObstacles()
        
        // 5. Collectibles updaten
        updateCollectibles()
        
        // 6. Spawning
        handleSpawning()
        
        // 7. Collision Detection
        checkCollisions()
    }
    
    // MARK: - Obstacles
    
    private func updateObstacles() {
        for i in obstacles.indices {
            obstacles[i].update(speed: speed, deltaTime: 1.0 / 60.0)
        }
        // Inaktive entfernen
        obstacles.removeAll { !$0.isActive }
    }
    
    // MARK: - Collectibles
    
    private func updateCollectibles() {
        for i in collectibles.indices {
            collectibles[i].update(speed: speed)
        }
        // Eingesammelte und inaktive entfernen
        collectibles.removeAll { !$0.isActive || $0.isCollected }
    }
    
    // MARK: - Spawning
    
    private func handleSpawning() {
        // Obstacles (Warentrenner oder Steckdosenleiste)
        obstacleSpawnCounter -= 1
        if obstacleSpawnCounter <= 0 {
            spawnObstacle()
            obstacleSpawnInterval = randomSpawnInterval(
                minInterval: GameConfig.obstacleSpawnMin,
                maxInterval: GameConfig.obstacleSpawnMax
            )
            obstacleSpawnCounter = obstacleSpawnInterval
        }
        
        // Collectibles (Yummynudeln)
        collectibleSpawnCounter -= 1
        if collectibleSpawnCounter <= 0 {
            spawnCollectible()
            collectibleSpawnInterval = randomSpawnInterval(
                minInterval: GameConfig.collectibleSpawnMin,
                maxInterval: GameConfig.collectibleSpawnMax
            )
            collectibleSpawnCounter = collectibleSpawnInterval
        }
        
        // BLA-Pakete (fallen vom Regal)
        blaSpawnCounter -= 1
        if blaSpawnCounter <= 0 {
            if Double.random(in: 0...1) < GameConfig.blaSpawnChance {
                spawnBLA()
            }
            blaSpawnInterval = randomSpawnInterval(
                minInterval: GameConfig.blaSpawnMin,
                maxInterval: GameConfig.blaSpawnMax
            )
            blaSpawnCounter = blaSpawnInterval
        }
    }
    
    private func spawnObstacle() {
        let x = GameConfig.spawnX
        
        if Double.random(in: 0...1) < GameConfig.warentrennerChance {
            obstacles.append(.warentrenner(atX: x))
        } else {
            obstacles.append(.steckdosenleiste(atX: x))
        }
    }
    
    private func spawnCollectible() {
        // Nicht direkt auf einem Hindernis spawnen
        let x = GameConfig.spawnX + CGFloat.random(in: 0...80)
        collectibles.append(.yummynudeln(atX: x))
    }
    
    private func spawnBLA() {
        // BLA fällt irgendwo im sichtbaren Bereich
        let x = player.position.x + CGFloat.random(in: 80...500)
        let bla = Obstacle.blaPackage(atX: x, fromY: GameConfig.shelfTopY)
        obstacles.append(bla)
        
        // Warnung an View
        onBlaWarning?(x)
    }
    
    // MARK: - Collision Detection
    
    private func checkCollisions() {
        guard player.state != .dead else { return }
        
        let playerBox = player.hitbox
        
        // Hindernisse
        for obstacle in obstacles where obstacle.isActive {
            let obsBox = obstacle.hitbox
            
            if playerBox.intersects(obsBox) {
                player.die()
                onHit?()
                endGame()
                return
            }
        }
        
        // Collectibles
        for i in collectibles.indices {
            guard !collectibles[i].isCollected else { continue }
            
            if collectibles[i].canCollect(playerPosition: player.position) {
                collectibles[i].isCollected = true
                yummies += 1
                onCollect?()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func randomSpawnInterval(minInterval: Int, maxInterval: Int) -> Int {
        // Intervall wird kürzer je schneller das Spiel wird
        let speedFactor = Double(speed / GameConfig.startSpeed)
        let adjustedMin = Swift.max(40, Int(Double(minInterval) / speedFactor))
        let adjustedMax = Swift.max(adjustedMin + 20, Int(Double(maxInterval) / speedFactor))
        return Int.random(in: adjustedMin...adjustedMax)
    }
}

