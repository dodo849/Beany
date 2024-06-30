//
//  SettingView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/8/24.
//

import SwiftUI

import StackCoordinator

struct SettingView: View {
    
    var coordinator = BaseCoordinator<SettingLink>()
    
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
                    UserDefaultsRepository.save(isSoundOn, forKey: .isSoundOn)
                }
            Spacer()
            Button(action: { 
                coordinator.sheet = .contactUsSheet
            }) {
                Text("문의하기")
            }
        }
        .padding(.horizontal, PAGE_PADDING)
        .customBackButton {
            coordinator.path.removeLast()
        }
        .onAppear {
            isSoundOn = UserDefaultsRepository.get(forKey: .isSoundOn, false)
        }
    }
}

#Preview {
    SettingView()
}

struct ContactUsSheet: View {
    var body: some View {
        VStack {
            HStack {
                Text("문의")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                Text("do83430208@gmail.com")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
    }
}
