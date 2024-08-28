//
//  BundleUtil.swift
//  CineStoreApp
//
//  Created by Guillermo Herrera on 27/08/24.
//

import Foundation

struct BundleUtil {
    static func infoForKey(_ key: String) -> String {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "") ?? ""
    }
}
