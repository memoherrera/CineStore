//
//  Mock.swift
//  CineStoreAppTests
//
//  Created by Guillermo Herrera on 24/08/24.
//

import UIKit

class MockNavigationBar: UINavigationBar {
    var capturedIsTranslucent: Bool?
    var capturedTintColor: UIColor?
    var capturedStandardAppearance: UINavigationBarAppearance?

    override var isTranslucent: Bool {
        didSet {
            capturedIsTranslucent = isTranslucent
        }
    }

    override var tintColor: UIColor! {
        didSet {
            capturedTintColor = tintColor
        }
    }

    override var standardAppearance: UINavigationBarAppearance {
        get {
            return super.standardAppearance
        }
        set {
            capturedStandardAppearance = newValue
            super.standardAppearance = newValue
        }
    }
}

class MockTabBar: UITabBar {
    var capturedTintColor: UIColor?
    var capturedBarTintColor: UIColor?
    var capturedUnselectedItemTintColor: UIColor?
    var capturedStandardAppearance: UITabBarAppearance?

    override var tintColor: UIColor! {
        didSet {
            capturedTintColor = tintColor
        }
    }

    override var barTintColor: UIColor? {
        didSet {
            capturedBarTintColor = barTintColor
        }
    }

    override var unselectedItemTintColor: UIColor? {
        didSet {
            capturedUnselectedItemTintColor = unselectedItemTintColor
        }
    }

    override var standardAppearance: UITabBarAppearance {
        get {
            return super.standardAppearance
        }
        set {
            capturedStandardAppearance = newValue
            super.standardAppearance = newValue
        }
    }
}
