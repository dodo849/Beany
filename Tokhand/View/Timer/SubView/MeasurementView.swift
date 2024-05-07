//
//  MeasurementView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/7/24.
//

import Foundation
import SwiftUI

struct MeasurementView: View {
    let max: Int

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(stride(from: 0, to: max, by: 10)).reversed(), id: \.self) { index in
                VStack(spacing: 0) {
                    Spacer()
                    HStack(alignment: .bottom) {
                        Spacer()
                        if index % 20 == 0 && index != 0 {
                            Text("\(index)ml")
                                .offset(x: 0, y: 5)
                                .font(.system(size: 10))
                                .foregroundColor(.strongCoffee.opacity(0.5))
                        }
                        Rectangle()
                            .fill(.strongCoffee.opacity(0.5))
                            .frame(maxWidth: 10, maxHeight: 1)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
                
        }
        .ignoresSafeArea()
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    MeasurementView(max: 60)
}
