//
//  ListItemProtocol.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation

protocol ListItemProtocol: Identifiable {
    var id: Int { get set }
    var title: String { get set }
    var subtitle: String { get set }
    var description: String { get set }
    var imageUrl: String { get set }
}

struct ListItem: ListItemProtocol {
    var id: Int
    
    var title: String
    
    var subtitle: String
    
    var imageUrl: String
    
    var description: String
}
