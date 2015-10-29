import Foundation
import UIKit

public class AppearanceApplyingStrategy {
    
    public func apply(appearance: Appearance?, toNavigationController navigationController: UINavigationController, animated: Bool) {
        if let appearance = appearance {
            let navigationBar = navigationController.navigationBar
            let toolbar = navigationController.toolbar
            
            if animated {
                UIView.beginAnimations("transition", context: nil)
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.setAnimationDuration(0.33)
                UIView.setAnimationTransition(.None, forView: navigationBar, cache: false)
                UIView.setAnimationTransition(.None, forView: toolbar, cache: false)
                
                defer {
                    UIView.commitAnimations()
                }
            }
            
            let background = ImageRenderer.renderImageOfColor(appearance.navigationBarColor)
            navigationBar.setBackgroundImage(background, forBarMetrics: .Default)
            navigationBar.tintColor = appearance.navigationBarTintColor
            
            navigationBar.shadowImage = appearance.navigationBarDropsShadow ? nil : UIImage()
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName: appearance.navigationBarTintColor
            ]
            
            toolbar.setBackgroundImage(
                ImageRenderer.renderImageOfColor(appearance.toolbarColor),
                forToolbarPosition: .Any,
                barMetrics: .Default
            )
            toolbar.tintColor = appearance.toolbarTintColor
        }
    }
}