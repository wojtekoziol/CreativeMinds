//
//  CircularProfileImage.swift
//  CreativeMinds
//
//  Created by Wojciech Kozioł on 22/10/2024.
//

import PhotosUI
import SwiftUI

struct CircularProfilePicture: View {
    let image: UIImage?
    let size: Double
    let isLoading: Bool
    let onImagePick: ((PhotosPickerItem) -> Void)?

    @State private var profilePictureItem: PhotosPickerItem?

    init(image: UIImage?, size: Double, isLoading: Bool = false, onImagePick: ((PhotosPickerItem) -> Void)? = nil) {
        self.image = image
        self.size = size
        self.isLoading = isLoading
        self.onImagePick = onImagePick
    }

    @ViewBuilder var circularImage: some View {
        Circle()
            .fill(.graphite)
            .frame(width: size)
            .overlay {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: size)
                        .clipShape(.circle)
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
    }

    var body: some View {
        if let onImagePick {
            PhotosPicker(selection: $profilePictureItem, matching: .images) {
                circularImage
            }
            .onChange(of: profilePictureItem) {
                if let profilePictureItem {
                    onImagePick(profilePictureItem)
                }
            }
            .frame(width: size, height: size)
        } else {
            circularImage
        }
    }
}

#Preview {
    CircularProfilePicture(image: nil, size: 50)
}
