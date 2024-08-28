//
//  VerticalCardItem.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import SwiftUI
import Kingfisher

private enum Constant {
    static let imageSize = CGSize(width: 120, height: 165)
}

struct VerticalImageCard: View {
    let listItem: ListItem
    let showDetails: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            RemoteImageView(imageUrl: listItem.imageUrl, imageSize: Constant.imageSize, cornerRadius: 10)
            if showDetails {
                VStack(alignment: .leading, spacing: 10) {
                    Text(listItem.title)
                        .font(.headline)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color(UIColor.labelPrimary))
                    HStack {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.red)
                        Text(listItem.subtitle)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color(UIColor.labelPrimary))
                    }
                    Text(listItem.description)
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color(UIColor.labelPrimary))
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
