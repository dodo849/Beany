//
//  SoundHelper.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import Foundation
import AVFoundation

class SoundHelper {
    static let shared = SoundHelper()
    
    private init() {}
    
    var player: AVAudioPlayer?

    func playSound() {
        
        guard let url = Bundle.main.url(forResource: "sound", withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("사운드를 재생할 수 없습니다.")
        }
    }
}
