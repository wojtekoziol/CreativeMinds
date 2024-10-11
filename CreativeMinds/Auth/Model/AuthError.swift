//
//  AuthError.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import Foundation

enum AuthError: Error {
    case invalidEmail
    case wrongPassword
    case emailAlreadyInUse
    case weakPassword
    case unknown(String)
}
