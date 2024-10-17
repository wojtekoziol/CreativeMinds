//
//  BannerData.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 17/10/2024.
//

import SwiftUI

enum BannerType {
    case normal
    case success
    case error

    var backgroundColor: Color {
        switch self {
        case .normal:
                .accent
        case .success:
                .accent
        case .error:
                .error
        }
    }
}

struct BannerData {
    let type: BannerType
    let title: String
    let message: String?
    let emoji: String

    static let empty = BannerData(type: .normal, title: "", message: "", emoji: "")

    init(type: BannerType, title: String, message: String?, emoji: String) {
        self.type = type
        self.title = title
        self.message = message
        self.emoji = emoji
    }

    init(type: BannerType, title: String, emoji: String) {
        self.init(type: type, title: title, message: "", emoji: emoji)
    }
}
