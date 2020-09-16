
import Foundation
import UIKit

public protocol NavigationControllerAppearanceContext: class {
    
    func prefersBarHidden(for navigationController: UINavigationController) -> Bool
    func prefersToolbarHidden(for navigationController: UINavigationController) -> Bool
    func preferredAppearance(for navigationController: UINavigationController) -> Appearance?
    
    func setNeedsUpdateNavigationControllerAppearance()
}

extension NavigationControllerAppearanceContext {
    
    func prefersBarHidden(for navigationController: UINavigationController) -> Bool {
        return false
    }
    
    func prefersToolbarHidden(for navigationController: UINavigationController) -> Bool {
        return true
    }
    
    func preferredAppearance(for navigationController: UINavigationController) -> Appearance? {
        return nil
    }
    
    func setNeedsUpdateNavigationControllerAppearance() {
        if let viewController = self as? UIViewController,
            let navigationController = viewController.navigationController as? AppearanceNavigationController {
            navigationController.updateAppearance(for: viewController)
        }
    }
}
