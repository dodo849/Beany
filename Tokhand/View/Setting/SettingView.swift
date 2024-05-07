//
//  SettingView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/8/24.
//

import SwiftUI

import StackCoordinator

struct SettingView: View {
    
    var coordinator = BaseCoordinator<TimerLink>()
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("문의")
                    .font(.system(size: 14))
                .foregroundColor(.gray)
                Text("do83430208@gmail.com")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            Text("Sponsored by Sven")
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.gray.opacity(0.3))
                .cornerRadius(5)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.7))
        }
        .customBackButton {
            coordinator.path.removeLast()
        }
    }
}

#Preview {
    SettingView()
}
