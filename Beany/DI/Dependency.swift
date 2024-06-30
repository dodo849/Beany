//
//  Dependency.swift
//  Beany
//
//  Created by DOYEON LEE on 6/12/24.
//

import Dependencies

private enum TimerCompleteSoundHelperKey: DependencyKey {
    static let liveValue: SoundHelper = SoundSettingDecorator(TimerCompleteSoundHelper())
}

extension DependencyValues {
  var timerCompleteSoundHelper: SoundHelper {
    get { self[TimerCompleteSoundHelperKey.self] }
    set { self[TimerCompleteSoundHelperKey.self] = newValue }
  }
}

private enum NextStepSoundHelperKey: DependencyKey {
    static let liveValue: SoundHelper = SoundSettingDecorator(NextStepSoundHelper())
}

extension DependencyValues {
  var nextStepSoundHelper: SoundHelper {
    get { self[NextStepSoundHelperKey.self] }
    set { self[NextStepSoundHelperKey.self] = newValue }
  }
}

private enum TimerToggleSoundHelperKey: DependencyKey {
    static let liveValue: SoundHelper = SoundSettingDecorator(TimerToggleSoundHelper())
}

extension DependencyValues {
  var timerToggleSoundHelper: SoundHelper {
    get { self[TimerToggleSoundHelperKey.self] }
    set { self[TimerToggleSoundHelperKey.self] = newValue }
  }
}
