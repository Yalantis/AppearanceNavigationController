//
//  AppearanceScheme+Random.swift
//  AppearanceNavigationController
//
//  Created by zen on 28/10/15.
//  Copyright © 2015 Zen. All rights reserved.
//

import Foundation
import UIKit

extension AppearanceScheme {
    
    static func randomScheme() -> AppearanceScheme {
        var value = AppearanceScheme()
        value.navigationBarDropsShadow = arc4random_uniform(2) == 1

        value.navigationBarColor = UIColor.randomColor()
        value.navigationBarTintColor = UIColor.randomColor()
        value.toolbarColor = UIColor.randomColor()
        value.toolbarTintColor = UIColor.randomColor()
    }
}