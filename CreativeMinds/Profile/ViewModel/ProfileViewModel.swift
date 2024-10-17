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
            bannerData = BannerData(type: .error, title: err.localizedDescription, emoji: "😢")
            showBanner = true
        }
    }

    func updateUsername(for userId: String) async {
        let result = await db.updateUsername(username.trimmingCharacters(in: .whitespacesAndNewlines), for: userId)
        switch result {
        case .success(let username):
            self.username = username
        case .failure(let err):
            bannerData = BannerData(type: .error, title: err.localizedDescription, emoji: "😢")
            showBanner = true
        }
    }
}
