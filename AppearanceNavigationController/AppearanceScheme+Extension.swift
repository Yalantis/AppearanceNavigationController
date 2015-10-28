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

        let navigationBarColor = UIColor.randomColor()
        value.navigationBarColor = navigationBarColor
        value.navigationBarTintColor = navigationBarColor.brightness > 0.5 ? UIColor.blackColor() : UIColor.whiteColor()
        
        let toolbarColor = UIColor.randomColor()
        value.toolbarColor = toolbarColor
        value.toolbarTintColor = toolbarColor.brightness > 0.5 ? UIColor.blackColor() : UIColor.whiteColor()
        
        value.statusBarStyle = navigationBarColor.brightness > 0.5 ? .Default : .LightContent
        
        return value
    }
    
    static let lightScheme: AppearanceScheme = {
        var value = AppearanceScheme()
        value.navigationBarDropsShadow = true
        value.navigationBarColor = UIColor.lightGrayColor()
        value.navigationBarTintColor = UIColor.whiteColor()
        value.statusBarStyle = .LightContent
        return value
    }()
}