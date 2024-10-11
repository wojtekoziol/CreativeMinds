//
//  CreativeMindsApp.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import SwiftUI

@main
struct CreativeMindsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            AuthWrapperView()
        }
    }
}
