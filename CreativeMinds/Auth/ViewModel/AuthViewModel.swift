//
//  AuthController.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import Foundation

@Observable class AuthViewModel {
    enum LoginType {
        case signIn
        case signUp
    }

    let auth: AuthService

    var user: User?
    private var type = LoginType.signIn

    init(auth: AuthService) {
        self.auth = auth
    }

    private func signUp(email: String, password: String) async {
        let userResult = await auth.signUp(email: email, password: password)
        user = try? userResult.get()
    }

    private func signIn(email: String, password: String) async {
        let userResult = await auth.signIn(email: email, password: password)
        user = try? userResult.get()
    }

    func signOut() async {
        await auth.signOut()
        user = nil
    }

    func switchLoginType() {
        switch type {
        case .signIn:
            type = .signUp
        case .signUp:
            type = .signIn
        }
    }

    var isLoggedIn: Bool {
        user != nil
    }

    var actionButtonText: String {
        switch type {
        case .signIn:
            "Sign In"
        case .signUp:
            "Sign Up"
        }
    }

    var action: ((String, String) async -> Void) {
        switch type {
        case .signIn:
            signIn(email:password:)
        case .signUp:
            signUp(email:password:)
        }
    }

    var switchButtonText: String {
        switch type {
        case .signIn:
            "Create an account"
        case .signUp:
            "Already have an account?"
        }
    }
}
