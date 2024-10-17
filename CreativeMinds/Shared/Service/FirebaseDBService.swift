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
    private let postsCollectionName = "posts"

    func addUser(_ user: User) async {
        guard let id = user.id else { return }
        let ref = db.collection(usersCollectionName).document(id)
        try? ref.setData(from: user)
    }

    func fetchUser(withId id: String) async -> Result<User, DBError> {
        do {
            let ref = db.collection(usersCollectionName).document(id)
            let user = try await ref.getDocument(as: User.self)
            return .success(user)
        } catch is FirestoreDecodingError {
            return .failure(.decoding)
        } catch is FirestoreErrorCode {
            return .failure(.badResponse)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    func addPost(_ post: Post, from userId: String) async {
        let postsRef = db.collection(postsCollectionName)
        let postRef = try? postsRef.addDocument(from: post)

        let usersRef = db.collection(usersCollectionName).document(userId)
        let user = try? await usersRef.getDocument(as: User.self)
        let updatedPosts = (user?.posts ?? []) + [postRef?.documentID]

        try? await usersRef.updateData([
            "posts": updatedPosts
        ])
    }

    func fetchAllPosts() async -> Result<[Post], DBError> {
        var posts = [Post]()
        do {
            let ref = db.collection(postsCollectionName)
            let snapshot = try await ref.getDocuments()

            for docSnapshot in snapshot.documents {
                let post = try docSnapshot.data(as: Post.self)
                posts.append(post)
            }

            return .success(posts)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    func fetchUsername(for id: String) async -> Result<String, DBError> {
        do {
            let ref = db.collection(usersCollectionName).document(id)
            let snapshot = try await ref.getDocument()
            let user = try snapshot.data(as: User.self)
            return .success(user.username)
        } catch is FirestoreDecodingError {
            return .failure(.decoding)
        } catch is FirestoreErrorCode {
            return .failure(.badResponse)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    func updateUsername(_ username: String, for id: String) async -> Result<String, DBError> {
        let ref = db.collection(usersCollectionName).document(id)
        do {
            try await ref.updateData([
                "username": username
            ])
            return .success(username)
        } catch is FirestoreErrorCode {
            return .failure(.badResponse)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }

    }
}
