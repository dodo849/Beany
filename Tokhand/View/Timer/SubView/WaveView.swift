//
//  WaveView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI

struct WaveView: View {
    let WAVE_CIRCLE_SIZE: CGFloat = UIScreen.main.bounds.width * 4
    
    var waveOffset: Int
    
    var body: some View {
        ZStack(alignment: .center){
//            RoundedRectangle(cornerRadius: WAVE_CIRCLE_SIZE / 2.3)
//                .fill(Color.coffee.opacity(0.7))
//                .frame(
//                    width: WAVE_CIRCLE_SIZE,
//                    height: WAVE_CIRCLE_SIZE
//                )
//                .rotationEffect(
//                    .degrees(Double(-waveOffset % 360 * 20))
//                )
//                .offset(x: -WAVE_CIRCLE_SIZE / 4 * 1.5, y: -20)
//                .animation(.linear(duration: 1), value: waveOffset)
//            
//            RoundedRectangle(cornerRadius: WAVE_CIRCLE_SIZE / 2.2)
//                .fill(Color.coffee.opacity(0.7))
//                .frame(
//                    width: WAVE_CIRCLE_SIZE,
//                    height: WAVE_CIRCLE_SIZE
//                )
//                .rotationEffect(
//                    .degrees(Double(waveOffset % 360 * 30))
//                )
//                .offset(x: -WAVE_CIRCLE_SIZE / 4 * 1.5, y: -20)
//                .animation(.linear(duration: 1), value: waveOffset)
//            
//            RoundedRectangle(cornerRadius: WAVE_CIRCLE_SIZE / 2.2)
//                .fill(Color.coffee.opacity(0.7))
//                .frame(
//                    width: WAVE_CIRCLE_SIZE,
//                    height: WAVE_CIRCLE_SIZE
//                )
//                .rotationEffect(
//                    .degrees(Double(-waveOffset % 360 * 20 + 20))
//                )
//                .offset(x: -WAVE_CIRCLE_SIZE / 4 * 1.5, y: -20)
//                .animation(.linear(duration: 1), value: waveOffset)
            Rectangle()
                .fill(Color.coffee.opacity(0.7))
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height)
            
        }
    }
}
