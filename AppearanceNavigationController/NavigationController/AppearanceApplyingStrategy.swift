import Foundation
import UIKit
import QuartzCore

public class AppearanceApplyingStrategy {
    
    public func apply(appearance: Appearance?, toNavigationController navigationController: UINavigationController, animated: Bool) {
        if let appearance = appearance {
            let navigationBar = navigationController.navigationBar
            let toolbar = navigationController.toolbar
            
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