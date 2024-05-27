//
//  TestWave.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/20/24.
//

import Foundation
import SwiftUI

struct TestWaveView: View {
    @State private var amplitude: CGFloat = 5

    var body: some View {
        WaveShape(amplitude: amplitude)
            .fill(Color.blue)
            .frame(height: 200)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 2)
                        .repeatForever(autoreverses: true)
                ) {
                    amplitude = 10
                }
            }
    }
}

private struct WaveShape: Shape {
    var amplitude: CGFloat

    var animatableData: CGFloat {
        get { amplitude }
        set { amplitude = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midWidth = width / 2
        let baseHeight = height / 2

        path.move(to: CGPoint(x: 0, y: baseHeight))

        for x in stride(from: 0, to: width, by: 1) {
            let relativeX = x / midWidth
            let sine = sin(relativeX * .pi * 2)
            let y = amplitude * sine
            path.addLine(to: CGPoint(x: x, y: baseHeight + y))
        }

        path.addLine(to: CGPoint(x: width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()

        return path
    }
}

#Preview {
    TestWaveView()
}
