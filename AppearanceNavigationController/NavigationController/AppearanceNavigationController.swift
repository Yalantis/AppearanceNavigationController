
import Foundation
import UIKit

open class AppearanceNavigationController: UINavigationController, UINavigationControllerDelegate {

    public required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        delegate = self
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        delegate = self
    }
    
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        delegate = self
    }
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - UINavigationControllerDelegate
    
    open func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController, animated: Bool
    ) {
        guard let appearanceContext = viewController as? NavigationControllerAppearanceContext else {
            return
        }
        
        setNavigationBarHidden(appearanceContext.prefersNavigationControllerBarHidden(self), animated: animated)
        setToolbarHidden(appearanceContext.prefersNavigationControllerToolbarHidden(self), animated: animated)
        applyAppearance(appearanceContext.preferredNavigationControllerAppearance(self), animated: animated)
        
        // interactive gesture requires more complex logic. 
        guard let coordinator = viewController.transitionCoordinator, coordinator.isInteractive else {
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in }, completion: { context in
            if context.isCancelled, let appearanceContext = self.topViewController as? NavigationControllerAppearanceContext {
                // hiding navigation bar & toolbar within interaction completion will result into inconsistent UI state
                self.setNavigationBarHidden(appearanceContext.prefersNavigationControllerBarHidden(self), animated: animated)
                self.setToolbarHidden(appearanceContext.prefersNavigationControllerToolbarHidden(self), animated: animated)
            }
        })
        
        coordinator.notifyWhenInteractionEnds { context in
            let key = UITransitionContextViewControllerKey.from
            if context.isCancelled, let from = context.viewController(forKey: key) as? NavigationControllerAppearanceContext {
                // changing navigation bar & toolbar appearance within animate completion will result into UI glitch
                self.applyAppearance(from.preferredNavigationControllerAppearance(self), animated: true)
            }
        }
    }

    // mark: - Appearance Applying
    
    fileprivate var appliedAppearance: Appearance?
    
    fileprivate func applyAppearance(_ appearance: Appearance?, animated: Bool) {
        if appearance != nil && appliedAppearance != appearance {
            appliedAppearance = appearance
            
            appearanceApplyingStrategy.apply(appearance, toNavigationController: self, animated: animated)
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    open var appearanceApplyingStrategy = AppearanceApplyingStrategy() {
        didSet {
            applyAppearance(appliedAppearance, animated: false)
        }
    }
    
    // mark: - Apperanace Update
    
    func updateAppearanceForViewController(_ viewController: UIViewController) {
        if let
            context = viewController as? NavigationControllerAppearanceContext,
            viewController == topViewController && transitionCoordinator == nil
        {
            setNavigationBarHidden(context.prefersNavigationControllerBarHidden(self), animated: true)
            setToolbarHidden(context.prefersNavigationControllerToolbarHidden(self), animated: true)
            applyAppearance(context.preferredNavigationControllerAppearance(self), animated: true)
        }
    }

    open func updateAppearance() {
        if let top = topViewController {
            updateAppearanceForViewController(top)
        }
    }
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return appliedAppearance?.statusBarStyle ?? super.preferredStatusBarStyle
    }

    override open var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return appliedAppearance != nil ? .fade : super.preferredStatusBarUpdateAnimation
    }
}
