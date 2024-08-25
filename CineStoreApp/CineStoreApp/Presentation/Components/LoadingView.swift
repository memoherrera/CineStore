//
//  LoadingView.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import SwiftUI

/// Presents an activity indicator and hides child content while activity indicator is active
struct LoadingView<Content>: View where Content: View {
    @Binding var isShowing: Bool

    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                content()
                    .disabled(isShowing)
                ActivityIndicator(isAnimating: .constant(true), style: .large)
                    .frame(minWidth: 78,
                           idealWidth: nil,
                           maxWidth: nil,
                           minHeight: 78,
                           idealHeight: nil,
                           maxHeight: nil,
                           alignment: .center)
                    .background(Color(UIColor.backgroundPrimary))
                    .cornerRadius(6)
                    .opacity(isShowing ? 1 : 0)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

