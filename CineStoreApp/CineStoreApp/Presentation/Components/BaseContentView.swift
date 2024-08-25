//
//  BaseContentView.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 24/08/24.
//

import SwiftUI

/// Handles common functionality like showing a loading indicator and applying styling
struct BaseContentView<Content>: View where Content: View {
    @Binding private var isLoading: Bool
    private var title: String?

    var content: () -> Content

    init(isLoading: Binding<Bool> = .constant(false),
         title: String? = nil,
         content: @escaping () -> Content) {
        _isLoading = isLoading
        self.title = title
        self.content = content
    }

    var body: some View {
        LoadingView(isShowing: $isLoading) {
            content()
        }
        .navigationTitle(title ?? "")
        .background(Color(UIColor.backgroundPrimary))
    }
}
