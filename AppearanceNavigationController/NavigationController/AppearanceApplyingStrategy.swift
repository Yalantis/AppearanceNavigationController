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
            
            if !navigationController.navigationBarHidden {
                let background = ImageRenderer.renderImageOfColor(appearance.navigationBar.backgroundColor)
                navigationBar.setBackgroundImage(background, forBarMetrics: .Default)
                navigationBar.tintColor = appearance.navigationBar.tintColor
                navigationBar.barTintColor = appearance.navigationBar.barTintColor
                navigationBar.titleTextAttributes = [
                    NSForegroundColorAttributeName: appearance.navigationBar.tintColor
                ]
            }

            if !navigationController.toolbarHidden {
                toolbar.setBackgroundImage(
                    ImageRenderer.renderImageOfColor(appearance.toolbar.backgroundColor),
                    forToolbarPosition: .Any,
                    barMetrics: .Default
                )
                toolbar.tintColor = appearance.toolbar.tintColor
                toolbar.barTintColor = appearance.toolbar.barTintColor
            }
        }
    }
}