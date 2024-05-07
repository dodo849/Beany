//
//  TimeFormatHelper.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/7/24.
//

import Foundation

class TimeFormatHelper {
    static func secondsToTimeString(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        
        if minutes == 0 {
            return "\(remainingSeconds)초"
        } else if remainingSeconds == 0 {
            return "\(minutes)분"
        } else {
            return "\(minutes)분 \(remainingSeconds)초"
        }
    }
}
