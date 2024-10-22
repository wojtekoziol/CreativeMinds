//
//  FetchError.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import Foundation

enum DBError: CustomDebugStringConvertible, Error, LocalizedError {
    case badResponse
    case encoding
    case decoding
    case unauthorizedAccess
    case largeFile
    case fileNotFound
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .encoding, .decoding:
            "Something went wrong. Please contact support."
        case .badResponse, .unknown(_), .fileNotFound:
            "Something went wrong. Please try again later."
        case .unauthorizedAccess:
            "Unauthorized access. Please contact support."
        case .largeFile:
            "Your file is too large. Reduce the size and try again."
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
        case .encoding:
            "DBError - Encoding"
        case .largeFile:
            "DBError - Large file"
        case .fileNotFound:
            "DBError - File not found"
        }
    }
}
