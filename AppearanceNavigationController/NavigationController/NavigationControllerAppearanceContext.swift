
import Foundation
import UIKit

public protocol NavigationControllerAppearanceContext: class {
    
    func prefersNavigationControllerBarHidden(_ navigationController: UINavigationController) -> Bool
    func prefersNavigationControllerToolbarHidden(_ navigationController: UINavigationController) -> Bool
    func preferredNavigationControllerAppearance(_ navigationController: UINavigationController) -> Appearance?
    
    func setNeedsUpdateNavigationControllerAppearance()
}

extension NavigationControllerAppearanceContext {
    
    func prefersNavigationControllerBarHidden(_ navigationController: UINavigationController) -> Bool {
        return false
    }
    
    func prefersNavigationControllerToolbarHidden(_ navigationController: UINavigationController) -> Bool {
        return true
    }
    
    func preferredNavigationControllerAppearance(_ navigationController: UINavigationController) -> Appearance? {
        return nil
    }
    
    func setNeedsUpdateNavigationControllerAppearance() {
        if let
            viewController = self as? UIViewController,
            let navigationController = viewController.navigationController as? AppearanceNavigationController
        {
            navigationController.updateAppearanceForViewController(viewController)
        }
    }
}
