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

    func addPost(_ post: Post) async
    func fetchAllPosts() async -> Result<[Post], DBError>
}
