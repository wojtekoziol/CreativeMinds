//
//  FirebaseDBService.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation

class FirebaseDBService: DBService {
    private let maxProfilePictureSize: Int64 = 3 * 1024 * 1024

    private let db = Firestore.firestore()
    private let usersCollectionName = "users"
    private let postsCollectionName = "posts"

    private let storage = Storage.storage()
    private var profilePicturesStorageRef: StorageReference {
        storage.reference(withPath: "profilepictures")
    }

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

    func deletePost(_ post: Post) async -> Result<String, DBError> {
        guard let postId = post.id else { return .failure(.decoding)}
        do {
            let postRef = db.collection(postsCollectionName).document(postId)
            try await postRef.delete()

            let userRef = db.collection(usersCollectionName).document(post.authorId)
            let user = try await userRef.getDocument(as: User.self)
            let updatedPosts = user.posts.filter { $0 != postId }

            try await userRef.updateData([
                "posts": updatedPosts
            ])

            return .success(postId)
        } catch is FirestoreErrorCode {
            return .failure(.badResponse)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    func addComment(_ comment: Comment, to postId: String) async -> Result<Comment, DBError> {
        do {
            let postRef = db.collection(postsCollectionName).document(postId)
            let encodedComment = comment.firestoreEncoded()

            try await postRef.updateData([
                "comments": FieldValue.arrayUnion([encodedComment])
            ])

            return .success(comment)
        } catch is FirestoreEncodingError {
            return .failure(.encoding)
        } catch is FirestoreErrorCode {
            return .failure(.badResponse)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    func deleteComment(_ comment: Comment, from postId: String) async -> Result<String, DBError> {
        do {
            let postRef = db.collection(postsCollectionName).document(postId)
            let encodedComment = comment.firestoreEncoded()

            try await postRef.updateData([
                "comments": FieldValue.arrayRemove([encodedComment])
            ])

            return .success(comment.id)
        } catch is FirestoreErrorCode {
            return .failure(.badResponse)
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

    func uploadProfilePicture(picture: Data, for userId: String) async -> Result<Data, DBError> {
        guard picture.count <= maxProfilePictureSize else {
            return .failure(.largeFile)
        }

        let metadata = StorageMetadata()
        metadata.contentType = "image"

        let userPictureRef = profilePicturesStorageRef.child(userId)

        do {
            _ = try await userPictureRef.putDataAsync(picture, metadata: metadata)

            return .success(picture)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }

    func downloadProfilePicture(for userId: String) async -> Result<Data, DBError> {
        return await withCheckedContinuation { continuation in
            let userPictureRef = profilePicturesStorageRef.child(userId)

            userPictureRef.getData(maxSize: maxProfilePictureSize) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: .success(data))
                case .failure(let error):
                    continuation.resume(returning: .failure(DBError.unknown(error.localizedDescription)))
                }
            }
        }
    }
}
