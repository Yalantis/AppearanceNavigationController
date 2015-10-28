
import Foundation
import UIKit

public struct Appearance: Equatable {
    
    var navigationBarDropsShadow = false
    var statusBarStyle: UIStatusBarStyle = .Default
    var navigationBarColor = UIColor.clearColor()
    var navigationBarTintColor = UIColor.clearColor()
    var toolbarColor = UIColor.clearColor()
    var toolbarTintColor = UIColor.clearColor()
}

public func ==(lhs: Appearance, rhs: Appearance) -> Bool {
    return
        lhs.navigationBarColor == rhs.navigationBarDropsShadow &&
        lhs.statusBarStyle == rhs.statusBarStyle &&
        lhs.navigationBarColor == rhs.navigationBarColor &&
        lhs.navigationBarTintColor == rhs.navigationBarTintColor &&
        lhs.toolbarColor == rhs.toolbarColor &&
        lhs.toolbarTintColor == rhs.toolbarTintColor
}
