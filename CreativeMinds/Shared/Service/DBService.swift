//
//  DBService.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import Foundation

protocol DBService {
    func addUser(_ user: User) async
    func fetchUser(withId id: String) async -> Result<User, DBError>

    func addPost(_ post: Post, from userId: String) async
    func fetchAllPosts() async -> Result<[Post], DBError>
    func deletePost(_ post: Post) async -> Result<String, DBError>

    func addComment(_ comment: Comment, to postId: String) async -> Result<Comment, DBError>
    func deleteComment(_ comment: Comment, from postId: String) async -> Result<String, DBError>

    func fetchUsername(for id: String) async -> Result<String, DBError>
    func updateUsername(_ username: String, for id: String) async -> Result<String, DBError> 
}
