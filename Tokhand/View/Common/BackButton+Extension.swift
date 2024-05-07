//
//  BackButton+Extension.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/6/24.
//

import SwiftUI

extension View {
    func customBackButton(dismissAction: @escaping () -> Void) -> some View {
        return self.navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: {
                    dismissAction()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.strongCoffee)
                }
            )
    }
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
