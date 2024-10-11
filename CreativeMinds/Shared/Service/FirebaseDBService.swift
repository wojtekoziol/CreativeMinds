//
//  FirebaseDBService.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import FirebaseFirestore
import Foundation

class FirebaseDBService: DBService {
    private let db = Firestore.firestore()
    private let usersCollectionName = "users"

    func addUser(_ user: User) async {
        let ref = db.collection(usersCollectionName).document(user.id)
        try? ref.setData(from: user)
    }

    func fetchUser(withId id: String) async -> Result<User, DBError> {
        do {
            let ref = db.collection(usersCollectionName).document(id)
            let user = try await ref.getDocument(as: User.self)
            return .success(user)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
}
