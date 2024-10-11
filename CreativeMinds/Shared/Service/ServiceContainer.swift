//
//  ServiceContainer.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import Foundation

final class ServiceContainer {
    static let shared = ServiceContainer()

    let dbService: DBService
    let authService: AuthService

    private init() {
        dbService = FirebaseDBService()
        authService = FirebaseAuthService(db: dbService)
    }
}
