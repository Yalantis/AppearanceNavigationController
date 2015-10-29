import Foundation
import UIKit

public class AppearanceApplyingStrategy {
    
public func apply(appearance: Appearance?, toNavigationController navigationController: UINavigationController) {
    if let appearance = appearance {
        let background = ImageRenderer.renderImageOfColor(appearance.navigationBarColor)
        navigationController.navigationBar.setBackgroundImage(background, forBarMetrics: .Default)
        navigationController.navigationBar.tintColor = appearance.navigationBarTintColor
        
        navigationController.navigationBar.shadowImage = appearance.navigationBarDropsShadow ? nil : UIImage()
        navigationController.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: appearance.navigationBarTintColor
        ]
        
        navigationController.toolbar.setBackgroundImage(
            ImageRenderer.renderImageOfColor(appearance.toolbarColor),
            forToolbarPosition: .Any,
            barMetrics: .Default
        )
        navigationController.toolbar.tintColor = appearance.toolbarTintColor
    }
}
}