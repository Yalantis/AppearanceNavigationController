
import Foundation
import UIKit

public protocol AppearanceNavigationControllerContext: class {
    
    func prefersNavigationControllerBarHidden(navigationController: AppearanceNavigationController) -> Bool
    func prefersNavigationControllerToolbarHidden(navigationController: AppearanceNavigationController) -> Bool
    func preferredNavigationControllerAppearance(navigationController: AppearanceNavigationController) -> Appearance?
    
    func setNeedsUpdateNavigationControllerAppearance()
}

extension AppearanceNavigationControllerContext {
    
    func prefersNavigationControllerBarHidden(navigationController: AppearanceNavigationController) -> Bool {
        return false
    }
    
    func prefersNavigationControllerToolbarHidden(navigationController: AppearanceNavigationController) -> Bool {
        return true
    }
    
    func preferredNavigationControllerAppearance(navigationController: AppearanceNavigationController) -> Appearance? {
        return nil
    }
    
    func setNeedsUpdateNavigationControllerAppearance() {
        if let
            viewController = self as? UIViewController,
            navigationController = viewController.navigationController as? AppearanceNavigationController
        {
            navigationController.updateAppearanceForViewController(viewController)
        }
    }
}