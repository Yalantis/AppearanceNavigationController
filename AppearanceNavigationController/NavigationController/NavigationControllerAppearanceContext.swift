
import Foundation
import UIKit

public protocol NavigationControllerAppearanceContext: class {
    
    func prefersNavigationControllerBarHidden(navigationController: UINavigationController) -> Bool
    func prefersNavigationControllerToolbarHidden(navigationController: UINavigationController) -> Bool
    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance?
    
    func setNeedsUpdateNavigationControllerAppearance()
}

extension NavigationControllerAppearanceContext {
    
    func prefersNavigationControllerBarHidden(navigationController: UINavigationController) -> Bool {
        return false
    }
    
    func prefersNavigationControllerToolbarHidden(navigationController: UINavigationController) -> Bool {
        return true
    }
    
    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
        return nil
    }
    
    func setNeedsUpdateNavigationControllerAppearance() {
        if let
            viewController = self as? UIViewController,
            let navigationController = viewController.navigationController as? AppearanceNavigationController
        {
            navigationController.updateAppearanceForViewController(viewController: viewController)
        }
    }
}
