
import Foundation
import UIKit

public struct AppearanceScheme: Equatable {
    var navigationBarDropsShadow = false
    var statusBarStyle: UIStatusBarStyle = .Default
    var navigationBarColor = UIColor.clearColor()
    var navigationBarTintColor = UIColor.clearColor()
    var toolbarColor = UIColor.clearColor()
    var toolbarTintColor = UIColor.clearColor()
}

public func ==(lhs: AppearanceScheme, rhs: AppearanceScheme) -> Bool {
    return
        lhs.navigationBarColor == rhs.navigationBarDropsShadow &&
        lhs.statusBarStyle == rhs.statusBarStyle &&
        lhs.navigationBarColor == rhs.navigationBarColor &&
        lhs.navigationBarTintColor == rhs.navigationBarTintColor &&
        lhs.toolbarColor == rhs.toolbarColor &&
        lhs.toolbarTintColor == rhs.toolbarTintColor
}
