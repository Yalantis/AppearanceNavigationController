
import Foundation
import UIKit

public class AppearanceNavigationController: UINavigationController, UINavigationControllerDelegate {

    public required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        delegate = self
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        delegate = self
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - UINavigationControllerDelegate
    
    public func navigationController(
        navigationController: UINavigationController,
        willShowViewController viewController: UIViewController, animated: Bool
    ) {
        applyViewControllerAppearance(viewController, animated: animated)
        setNavigationBarHidden(viewController.prefersNavigationControllerBarHidden(self), animated: animated)
        setToolbarHidden(viewController.prefersNavigationControllerToolbarHidden(self), animated: animated)
        
        guard let coordinator = viewController.transitionCoordinator() where coordinator.isInteractive() else {
            return
        }
        
        coordinator.animateAlongsideTransition({ _ in }, completion: { context in
            if context.isCancelled(), let top = self.topViewController {
                // hiding navigation bar & toolbar within interaction completion will result into inconsistent UI state
                self.setNavigationBarHidden(top.prefersNavigationControllerBarHidden(self), animated: animated)
                self.setToolbarHidden(top.prefersNavigationControllerToolbarHidden(self), animated: animated)
            }
        })
        
        coordinator.notifyWhenInteractionEndsUsingBlock { context in
            if context.isCancelled(), let from = context.viewControllerForKey(UITransitionContextFromViewControllerKey) {
                // changing navigation bar & toolbar appearance within animate completion will result into UI glitch
                self.applyViewControllerAppearance(from, animated: animated)
            }
        }
    }
    
    private func applyAppearanceScheme(appearance: Appearance, animated: Bool) {
        appliedAppearance = appearance
        
        UIView.beginAnimations("transition", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.33)
        UIView.setAnimationTransition(.None, forView: navigationBar, cache: false)
        UIView.setAnimationTransition(.None, forView: toolbar, cache: false)
        
        setNeedsStatusBarAppearanceUpdate()
                
        UIView.commitAnimations()
    }
    
    private func applyViewControllerAppearance(controller: UIViewController, animated: Bool) {
        if let value = controller.preferredNavigationControllerAppearance(self) where value != appliedAppearance {
            applyAppearanceScheme(value, animated: animated)
        }
    }
    
    private var appliedAppearance: Appearance?
    
    private func updateAppearanceForViewController(viewController: UIViewController) {
        if let top = topViewController where top == viewController && transitionCoordinator() == nil {
            setNavigationBarHidden(viewController.prefersNavigationControllerBarHidden(self), animated: true)
            setToolbarHidden(viewController.prefersNavigationControllerToolbarHidden(self), animated: true)

            applyViewControllerAppearance(viewController, animated: true)
        }
    }
    
    public func updateAppearanceScheme() {
        if let top = topViewController {
            updateAppearanceForViewController(top)
        }
    }
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return appliedAppearance?.statusBarStyle ?? .Default
    }
}

public protocol AppearanceNavigationControllerContent {
    
    func prefersNavigationControllerBarHidden(navigationController: AppearanceNavigationController) -> Bool
    func prefersNavigationControllerToolbarHidden(navigationController: AppearanceNavigationController) -> Bool
    func preferredNavigationControllerAppearance(navigationController: AppearanceNavigationController) -> Appearance?
    
    func setNeedsUpdateNavigationControllerAppearanceScheme()
}

extension UIViewController: AppearanceNavigationControllerContent {
    
    public func prefersNavigationControllerBarHidden(navigationController: AppearanceNavigationController) -> Bool {
        return false
    }
    
    public func prefersNavigationControllerToolbarHidden(navigationController: AppearanceNavigationController) -> Bool {
        return true
    }
    
    public func preferredNavigationControllerAppearance(navigationController: AppearanceNavigationController) -> Appearance? {
        return nil
    }
    
    public func setNeedsUpdateNavigationControllerAppearanceScheme() {
        (navigationController as? AppearanceNavigationController)?.updateAppearanceForViewController(self)
    }
}