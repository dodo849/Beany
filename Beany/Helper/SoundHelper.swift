//
//  SoundHelper.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import Foundation
import AVFoundation

protocol SoundHelper {
    func play()
}

extension SoundHelper {
    var isSoundOn: Bool {
        return UserDefaultsRepository.get(
            forKey: .isSoundOn
        )
    }
}

struct SoundHelperProxy: SoundHelper {
    private let soundHelper: SoundHelper
    
    init(_ soundHelper: SoundHelper) {
        self.soundHelper = soundHelper
    }
    
    func play() {
        if isSoundOn {
            soundHelper.play()
        }
    }
}

struct TimerToggleSoundHelper: SoundHelper {
    func play() {
        AudioServicesPlaySystemSound(1105)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

struct NextStepSoundHelper: SoundHelper {
    func play() {
        AudioServicesPlaySystemSound(1107)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

struct TimerCompleteSoundHelper: SoundHelper {
    func play() {
        AudioServicesPlaySystemSound(1106)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
