//
//  TextFieldModifier.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 13/10/2024.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(.plain)
            .padding()
            .foregroundStyle(.white)
            .background(.graphite)
    }
}

extension View {
    func customTextFieldStyle() -> some View {
        modifier(TextFieldModifier())
    }
}
