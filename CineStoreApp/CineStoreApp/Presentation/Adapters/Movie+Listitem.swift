//
//  Movie+Listitem.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation

extension Movie {
    func toListItem() -> ListItem {
        let description = "\(self.releaseDate) | \(self.overview.limitedSubstring(maxLength: 100))"
        return .init(id: self.id,
                     title: self.title,
                     subtitle: "\(Int(self.voteAverage))/10",
                     imageUrl: self.posterUrl,
                     description: description)
    }
}
