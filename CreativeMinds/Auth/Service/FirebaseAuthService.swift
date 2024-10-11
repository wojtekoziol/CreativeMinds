//
//  FirebaseAuthService.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import FirebaseAuth
import Foundation

class FirebaseAuthService: AuthService {
    let db: DBService

    private var auth = Auth.auth()

    init(db: DBService) {
        self.db = db
    }

    func signUp(email: String, password: String) async -> Result<User, AuthError> {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            let user = User(id: result.user.uid, email: result.user.email ?? "", posts: [])
            await db.addUser(user)
            return .success(user)
        } catch AuthErrorCode.invalidEmail {
            return .failure(.invalidEmail)
        } catch AuthErrorCode.weakPassword {
            return .failure(.weakPassword)
        } catch AuthErrorCode.emailAlreadyInUse {
            return .failure(.emailAlreadyInUse)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
    func signIn(email: String, password: String) async -> Result<User, AuthError> {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            let userResult = await db.fetchUser(withId: authResult.user.uid)
            let user = try userResult.get()
            return .success(user)
        } catch AuthErrorCode.wrongPassword {
            return .failure(.wrongPassword)
        } catch AuthErrorCode.invalidEmail {
            return .failure(.invalidEmail)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
    func signOut() async {
        try? auth.signOut()
    }
}
