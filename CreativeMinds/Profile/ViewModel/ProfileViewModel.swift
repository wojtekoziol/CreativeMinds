//
//  ProfileViewModel.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 17/10/2024.
//

import Foundation

@Observable class ProfileViewModel {
    private let db: DBService

    var username = ""

    private(set) var bannerData = BannerData.empty
    var showBanner = false

    init(db: DBService) {
        self.db = db
    }

    func fetchUsername(for userId: String) async {
        let result = await db.fetchUsername(for: userId)
        switch result {
        case .success(let username):
            self.username = username
        case .failure(let err):
            bannerData = BannerData(type: .error, title: err.localizedDescription)
            showBanner = true
        }
    }

    func updateUsername(for userId: String) async {
        username = username.trimmingCharacters(in: .whitespaces)

        let result = await db.updateUsername(username, for: userId)
        switch result {
        case .success(let username):
            self.username = username
            bannerData = BannerData(type: .success, title: "Username updated successfully!")
            showBanner = true
        case .failure(let err):
            bannerData = BannerData(type: .error, title: err.localizedDescription)
            showBanner = true
        }
    }
}
