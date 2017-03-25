//
//  DiscountCardViewModel.swift
//  Discountcard
//
//  Created by ivan on 26/10/16.
//

import Foundation

private let kUserDefaultsUserNameKey = "userName"

class DiscountCardViewModel {

    private(set) var userName: String?

    init() {
        userName = UserDefaults.standard.string(forKey: kUserDefaultsUserNameKey)
    }

    func set(userName: String?) {
        self.userName = userName
        UserDefaults.standard.set(userName, forKey: kUserDefaultsUserNameKey)
        UserDefaults.standard.synchronize()
    }
}
