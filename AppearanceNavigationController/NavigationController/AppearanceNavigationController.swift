
import Foundation
import UIKit

public class AppearanceNavigationController: UINavigationController, UINavigationControllerDelegate {

    public required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        delegate = self
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
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
    
    public func navigationController(
        navigationController: UINavigationController,
        willShowViewController viewController: UIViewController, animated: Bool
    ) {
        guard let appearanceContext = viewController as? AppearanceNavigationControllerContext else {
            return
        }
        
        setNavigationBarHidden(appearanceContext.prefersNavigationControllerBarHidden(self), animated: animated)
        setToolbarHidden(appearanceContext.prefersNavigationControllerToolbarHidden(self), animated: animated)
        applyAppearance(appearanceContext.preferredNavigationControllerAppearance(self), animated: animated)
        
        // interactive gesture requires more complex logic. 
        guard let coordinator = viewController.transitionCoordinator() where coordinator.isInteractive() else {
            return
        }
        
        coordinator.animateAlongsideTransition({ _ in }, completion: { context in
            if context.isCancelled(), let appearanceContext = self.topViewController as? AppearanceNavigationControllerContext {
                // hiding navigation bar & toolbar within interaction completion will result into inconsistent UI state
                self.setNavigationBarHidden(appearanceContext.prefersNavigationControllerBarHidden(self), animated: animated)
                self.setToolbarHidden(appearanceContext.prefersNavigationControllerToolbarHidden(self), animated: animated)
            }
        })
        
        coordinator.notifyWhenInteractionEndsUsingBlock { context in
            let key = UITransitionContextFromViewControllerKey
            if context.isCancelled(), let from = context.viewControllerForKey(key) as? AppearanceNavigationControllerContext {
                // changing navigation bar & toolbar appearance within animate completion will result into UI glitch
                self.applyAppearance(from.preferredNavigationControllerAppearance(self), animated: true)
            }
        }
    }

    // mark: - Appearance Applying
    
    private var appliedAppearance: Appearance?
    
    private func applyAppearance(appearance: Appearance?, animated: Bool) {
        if appearance != nil && appliedAppearance != appearance {
            appliedAppearance = appearance
            
            appearanceApplyingStrategy.apply(appearance, toNavigationController: self, animated: animated)
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    public var appearanceApplyingStrategy = AppearanceApplyingStrategy() {
        didSet {
            applyAppearance(appliedAppearance, animated: false)
        }
    }
    
    // mark: - Apperanace Update
    
    func updateAppearanceForViewController(viewController: UIViewController) {
        if let
            context = viewController as? AppearanceNavigationControllerContext
            where
            viewController == topViewController && transitionCoordinator() == nil
        {
            setNavigationBarHidden(context.prefersNavigationControllerBarHidden(self), animated: true)
            setToolbarHidden(context.prefersNavigationControllerToolbarHidden(self), animated: true)
            applyAppearance(context.preferredNavigationControllerAppearance(self), animated: true)
        }
    }

    public func updateAppearance() {
        if let top = topViewController {
            updateAppearanceForViewController(top)
        }
    }
    
    override public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return appliedAppearance?.statusBarStyle ?? super.preferredStatusBarStyle()
    }

    override public func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return appliedAppearance != nil ? .Fade : super.preferredStatusBarUpdateAnimation()
    }
}