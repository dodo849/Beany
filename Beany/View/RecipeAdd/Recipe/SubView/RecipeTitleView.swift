//
//  RecipeTitleView.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/7/24.
//

import SwiftUI

struct RecipeTitleView: View {
    let plusAction: () -> Void
    var body: some View {
        HStack {
            Text("레시피")
                .font(.system(size: 24, weight: .bold, design: .rounded))
            Spacer()
            Image(systemName: "plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .onTapGesture { plusAction() }
        }
    }
}
