//
//  FirstInstallAction.swift
//  Tokhand
//
//  Created by DOYEON LEE on 5/7/24.
//

import Foundation

@MainActor
final class FirstInstallAction {
    
    static let shared = FirstInstallAction()
    
    private init() {
        self.defaultRecipeId = defaultRecipe.id
    }
    
    private var context = sharedModelContainer.mainContext
    
    private let defaultRecipe: Recipe = .init(
        name: "기본 레시피",
        steps: [
            .init(order: 0, name: "뜸들이기", helpText: "원두를 충분히 적셔주세요", seconds: 60, water: 40),
            .init(order: 1, name: "첫번째 추출", helpText: "가운데부터 균일한 속도로 물을 부어주세요", seconds: 60, water: 80),
            .init(order: 2, name: "두번째 추출", helpText: "속도를 조금 높여 물을 부어주세요", seconds: 40, water: 40)
        ],
        author: .admin
    )
    let defaultRecipeId: UUID
    
    func execute() {
        let hasBeenInstalledBefore: Bool = UserDefaultsRepository.get(
            forKey: .isFirstInstall,
            false
        )

        if !hasBeenInstalledBefore {
            setDefaultRecipe()
            setDefaultSoundSetting()
        }
    }
    
    private func setDefaultRecipe() {
        context.insert(defaultRecipe)
        UserDefaultsRepository.save(true, forKey: .isFirstInstall)
        UserDefaultsRepository.save(
            defaultRecipe.id.uuidString,
            forKey: .selectedRecipeId
        )
        do {
            try context.save()
        } catch {
            fatalError("model context save failed")
        }
    }
    
    private func setDefaultSoundSetting() {
        UserDefaultsRepository.save(
            true,
            forKey: .isSoundOn
        )
    }
}
