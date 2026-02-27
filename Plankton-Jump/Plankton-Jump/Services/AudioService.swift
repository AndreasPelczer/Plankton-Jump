//
//  AudioService.swift
//  Plankton-Jump
//
//  Created by Andreas Pelczer on 27.02.26.
//

import AVFoundation

class AudioService {
    static let shared = AudioService()

    private var backgroundPlayer: AVAudioPlayer?
    private var sfxPlayer: AVAudioPlayer?

    private init() {}

    func playBackgroundMusic(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        do {
            backgroundPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundPlayer?.numberOfLoops = -1
            backgroundPlayer?.play()
        } catch {
            print("Background music error: \(error)")
        }
    }

    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
    }

    func playSFX(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else { return }
        do {
            sfxPlayer = try AVAudioPlayer(contentsOf: url)
            sfxPlayer?.play()
        } catch {
            print("SFX error: \(error)")
        }
    }
}
