//
//  AuthService.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import Foundation

protocol AuthService {
    func signUp(email: String, password: String) async -> Result<User, AuthError>
    func signIn(email: String, password: String) async -> Result<User, AuthError>
    func signOut() async
}
