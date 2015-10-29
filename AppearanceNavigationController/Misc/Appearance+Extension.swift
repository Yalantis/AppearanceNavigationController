
import Foundation
import UIKit

extension Appearance {
    
    static func random() -> Appearance {
        var value = Appearance()
        
        let navigationBarColor = UIColor.randomColor()
        value.navigationBarColor = navigationBarColor
        value.navigationBarTintColor = navigationBarColor.isBright ? UIColor.blackColor() : UIColor.whiteColor()
        
        let toolbarColor = UIColor.randomColor()
        value.toolbarColor = toolbarColor
        value.toolbarTintColor = toolbarColor.isBright ? UIColor.blackColor() : UIColor.whiteColor()
        
        value.statusBarStyle = navigationBarColor.brightness > 0.5 ? .Default : .LightContent
        value.navigationBarDropsShadow = arc4random_uniform(2) == 1
        
        return value
    }
    
    static let lightAppearance: Appearance = {
        var value = Appearance()
        
        value.navigationBarDropsShadow = true
        value.navigationBarColor = UIColor.lightGrayColor()
        value.navigationBarTintColor = UIColor.whiteColor()
        value.statusBarStyle = .LightContent
        
        return value
    }()
    
    func inverse() -> Appearance {
        var value = Appearance()
        
        value.navigationBarColor = navigationBarColor.inversedColor
        value.navigationBarTintColor = navigationBarTintColor.inversedColor
        value.toolbarColor = toolbarColor.inversedColor
        value.toolbarTintColor = toolbarTintColor.inversedColor
        value.statusBarStyle = value.navigationBarColor.brightness > 0.5 ? .Default : .LightContent
        value.navigationBarDropsShadow = !navigationBarDropsShadow

        return value
    }
}