//
//  RemoteImageView.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import SwiftUI

import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    let imageUrl: String
    let imageSize: CGSize
    let cornerRadius: CGFloat
    
    @State private var isLoading = true
    @State private var imageLoadFailed = false
    
    struct FailedMediaView: View {
        let imageSize: CGSize
        var body: some View {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: imageSize.width, height: imageSize.height )
                .foregroundColor(.gray)
        }
    }
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView() // Show a loading indicator while the image is loading
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: imageSize.width, height: imageSize.height)
            }
            
            KFImage(URL(string: imageUrl))
                .onSuccess { _ in
                    isLoading = false
                    imageLoadFailed = false
                }
                .onFailure { _ in
                    isLoading = false
                    imageLoadFailed = true
                }
                .placeholder {
                    EmptyView() // Placeholder not needed due to ProgressView
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imageSize.width, height: imageSize.height)
                .cornerRadius(cornerRadius)
            
            if imageLoadFailed {
                FailedMediaView(imageSize: self.imageSize)
            }
        }
    }
}
