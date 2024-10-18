//
//  FetchError.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import Foundation

enum DBError: CustomDebugStringConvertible, Error, LocalizedError {
    case badResponse
    case decoding
    case unauthorizedAccess
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .decoding:
            "Something went wrong. Please contact support."
        case .badResponse, .unknown(_):
            "Something went wrong. Please try again later."
        case .unauthorizedAccess:
            "Unauthorized access. Please contact support."
        }
    }

    var debugDescription: String {
        switch self {
        case .badResponse:
            "DBError - Bad response"
        case .decoding:
            "DBError - Decoding"
        case .unknown(let err):
            "DBError - Unknown: \(err)"
        case .unauthorizedAccess:
            "DBError - Unauthorized access"
        }
    }
}
