
import Foundation
import UIKit

extension Appearance {
    
    static func random() -> Appearance {
        var value = Appearance()
        
        let navigationBarColor = UIColor.randomColor()
        value.navigationBar.backgroundColor = navigationBarColor
        value.navigationBar.tintColor = navigationBarColor.isBright ? UIColor.blackColor() : UIColor.whiteColor()
        
        let toolbarColor = UIColor.randomColor()
        value.toolbar.backgroundColor = toolbarColor
        value.toolbar.tintColor = toolbarColor.isBright ? UIColor.blackColor() : UIColor.whiteColor()
        
        value.statusBarStyle = navigationBarColor.brightness > 0.5 ? .Default : .LightContent
        
        return value
    }
    
    func inverse() -> Appearance {
        var value = Appearance()
        
        value.navigationBar.backgroundColor = navigationBar.backgroundColor.inverse()
        value.navigationBar.tintColor = navigationBar.tintColor.inverse()
        value.toolbar.backgroundColor = toolbar.backgroundColor.inverse()
        value.toolbar.tintColor = toolbar.tintColor.inverse()
        value.statusBarStyle = value.navigationBar.backgroundColor.isBright ? .Default : .LightContent
        
        return value
    }
    
    static let lightAppearance: Appearance = {
        var value = Appearance()
        
        value.navigationBar.backgroundColor = UIColor.lightGrayColor()
        value.navigationBar.tintColor = UIColor.whiteColor()
        value.statusBarStyle = .LightContent
        
        return value
    }()
}