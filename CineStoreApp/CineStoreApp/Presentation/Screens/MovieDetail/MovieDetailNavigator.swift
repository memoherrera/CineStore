//
//  MovieDetailNavigator.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 26/08/24.
//

import Foundation
import LinkNavigator

struct MovieDetailNavigator: MovieDetailNavigatorProtocol {
    let navigation: MainRootNavigatorType

    func showError(message: String) {
        let action = ActionButton(title: "OK", style: .cancel)
        print(message)
        let alert = Alert(message: "An error happens trying to fetch the contet detail. Please try again", buttons: [action], flagType: .error)
        navigation.alert(model: alert)
    }
}
