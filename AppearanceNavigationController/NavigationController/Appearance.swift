
import Foundation
import UIKit

public struct Appearance: Equatable {
    
    public struct Bar: Equatable {
        
        var style: UIBarStyle = .default
        var backgroundColor = UIColor(red: 234 / 255, green: 46 / 255, blue: 73 / 255, alpha: 1)
        var tintColor = UIColor.white
        var barTintColor: UIColor?
    }
    
    var statusBarStyle: UIStatusBarStyle = .default
    var navigationBar = Bar()
    var toolbar = Bar()
}

public func ==(lhs: Appearance.Bar, rhs: Appearance.Bar) -> Bool {
    return lhs.style == rhs.style &&
        lhs.backgroundColor == rhs.backgroundColor &&
        lhs.tintColor == rhs.tintColor &&
        rhs.barTintColor == lhs.barTintColor
}

public func ==(lhs: Appearance, rhs: Appearance) -> Bool {
    return lhs.statusBarStyle == rhs.statusBarStyle && lhs.navigationBar == rhs.navigationBar && lhs.toolbar == rhs.toolbar
}
