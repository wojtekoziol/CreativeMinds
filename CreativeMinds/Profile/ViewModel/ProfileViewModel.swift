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
    private(set) var errorMessage: String?

    init(db: DBService) {
        self.db = db
    }

    func fetchUsername(for userId: String) async {
        errorMessage = nil

        let result = await db.fetchUsername(for: userId)
        switch result {
        case .success(let username):
            self.username = username
        case .failure(let err):
            errorMessage = err.errorDescription
        }
    }

    func updateUsername(for userId: String) async {
        await db.updateUsername(username.trimmingCharacters(in: .whitespacesAndNewlines), for: userId)
    }
}
