//
//  Encodable+Firestore.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 21/10/2024.
//

import FirebaseFirestore
import Foundation

extension Encodable {
    func firestoreEncoded() -> [String: Any] {
        (try? Firestore.Encoder().encode(self)) ?? [:]
    }
}
