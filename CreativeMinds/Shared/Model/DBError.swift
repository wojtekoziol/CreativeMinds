//
//  FetchError.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import Foundation

enum DBError: Error, LocalizedError {
    case badResponse
    case decoding
    case unknown(String)

    var errorDescription: String?  {
        switch self {
        case .decoding:
            "Something went wrong. Please contact support."
        case .badResponse, .unknown(_):
            "Something went wrong. Please try again later."
        }
    }
}
