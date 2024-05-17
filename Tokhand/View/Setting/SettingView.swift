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
    
    @State private var isSoundOn = true
    
    var body: some View {
        VStack {
            Toggle("소리 켜기/끄기", isOn: $isSoundOn)
                .font(.system(size: 16, weight: .semibold))
                .toggleStyle(SwitchToggleStyle(tint: .coffee))
                .onChange(
                    of: isSoundOn,
                    initial: true
                ) {
                    UserDefaults.standard.setValue(
                        isSoundOn,
                        forKey: UserDefaultConstant.isSoundOn
                    )
                }
            Spacer()
            HStack {
                Text("문의")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text("do83430208@gmail.com")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            //            Text("Sponsored by Sven")
            //                .padding(.horizontal, 10)
            //                .padding(.vertical, 5)
            //                .background(.gray.opacity(0.3))
            //                .cornerRadius(5)
            //                .font(.system(size: 12))
            //                .foregroundColor(.black.opacity(0.7))
        }
        .padding(.horizontal, PAGE_PADDING)
        .customBackButton {
            coordinator.path.removeLast()
        }
        .onAppear() {
            isSoundOn = UserDefaults.standard.bool(
                forKey: UserDefaultConstant.isSoundOn
            )
        }
    }
}

#Preview {
    SettingView()
}
