//
//  Banner.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 17/10/2024.
//

import SwiftUI

struct BannerModifier: ViewModifier {
    @Binding var show: Bool

    let data: BannerData

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if show {
                HStack {
                    Text(data.emoji)
                        .font(.largeTitle)

                    VStack(alignment: data.message != nil ? .leading : .center) {
                        Text(data.title)
                            .bold()

                        if let message = data.message {
                            Text(message)
                                .font(.caption)
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .padding()
                .background(data.type.backgroundColor)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 10)
                .padding()
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onTapGesture {
                    show = false
                }
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.height > 0 {
                                show = false
                            }
                        }
                )
                .onAppear {
                    Task {
                        try? await Task.sleep(nanoseconds: 5_000_000_000)
                        show = false
                    }
                }
            }
        }
        .animation(.bouncy(duration: 0.5), value: show)
    }
}

extension View {
    func banner(show: Binding<Bool>, with bannerData: BannerData) -> some View {
        modifier(BannerModifier(show: show, data: bannerData))
    }
}
