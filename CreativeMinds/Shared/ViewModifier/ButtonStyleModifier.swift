//
//  ButtonStyleModifier.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 11/10/2024.
//

import SwiftUI

struct ButtonStyleModifier: ViewModifier {
    let padding: Bool

    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 5)
            .foregroundStyle(.white)
            .background(.accent)
    }
}

extension View {
    func customButtonStyle(padding: Bool = true) -> some View {
        modifier(ButtonStyleModifier(padding: padding))
    }
}
