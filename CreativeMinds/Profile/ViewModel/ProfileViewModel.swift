//
//  ProfileViewModel.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 17/10/2024.
//

import PhotosUI
import SwiftUI

@Observable class ProfileViewModel {
    private let db: DBService

    var username = ""
    var profilePicture: UIImage?

    private(set) var isLoading = false
    private(set) var bannerData = BannerData.empty
    var showBanner = false

    var selectedPicture: PhotosPickerItem?

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

    func uploadProfilePicture(_ imageData: Data, for userId: String) async {
        isLoading = true

        let result = await db.uploadProfilePicture(picture: imageData, for: userId)
        switch result {
        case .success(let picture):
            profilePicture = UIImage(data: picture)
        case .failure(let err):
            bannerData = BannerData(type: .error, title: err.localizedDescription)
            showBanner = true
        }

        isLoading = false
    }

    func downloadProfilePicture(for userId: String) async {
        isLoading = true

        let result = await db.downloadProfilePicture(for: userId)
        switch result {
        case .success(let pictureData):
            profilePicture = UIImage(data: pictureData)
        case .failure(let err):
            debugPrint("ProfileViewModel - downloadProfilePicture(userId: \(userId)) - \(err.debugDescription)")
            bannerData = BannerData(type: .error, title: err.localizedDescription)
            showBanner = true
        }

        isLoading = false
    }
}
