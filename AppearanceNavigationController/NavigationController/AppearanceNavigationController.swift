
import Foundation
import UIKit

public class AppearanceNavigationController: UINavigationController, UINavigationControllerDelegate {
    
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
    
    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController, animated: Bool
    ) {
        guard let appearanceContext = viewController as? NavigationControllerAppearanceContext else {
            return
        }
        setNavigationBarHidden(appearanceContext.prefersBarHidden(for: self), animated: animated)
        setNavigationBarHidden(appearanceContext.prefersBarHidden(for: self), animated: animated)
        setToolbarHidden(appearanceContext.prefersToolbarHidden(for: self), animated: animated)
        applyAppearance(appearance: appearanceContext.preferredAppearance(for: self), animated: animated)
        
        // interactive gesture requires more complex logic. 
        guard let coordinator = viewController.transitionCoordinator, coordinator.isInteractive else {
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in }) { (context) in
            if context.isCancelled,
                let appearanceContext = self.topViewController as? NavigationControllerAppearanceContext {
                // hiding navigation bar & toolbar within interaction completion will result into inconsistent UI state
                self.setNavigationBarHidden(appearanceContext.prefersBarHidden(for: self), animated: animated)
                self.setToolbarHidden(appearanceContext.prefersToolbarHidden(for: self), animated: animated)
            }
        }
        
        coordinator.notifyWhenInteractionEnds { (context) in
            if context.isCancelled,
                let from = context.viewController(forKey: .from) as? NavigationControllerAppearanceContext {
                // changing navigation bar & toolbar appearance within animate completion will result into UI glitch
                self.applyAppearance(appearance: from.preferredAppearance(for: self), animated: animated)
            }
        }
    }
    
    // mark: - Appearance Applying
    
    private var appliedAppearance: Appearance?
    
    private func applyAppearance(appearance: Appearance?, animated: Bool) {
        if appearance != nil && appliedAppearance != appearance {
            appliedAppearance = appearance
            
            appearanceApplyingStrategy.apply(appearance: appearance, toNavigationController: self, animated: animated)
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    public var appearanceApplyingStrategy = AppearanceApplyingStrategy() {
        didSet {
            applyAppearance(appearance: appliedAppearance, animated: false)
        }
    }
    
    // mark: - Apperanace Update
    
    func updateAppearance(for viewController: UIViewController) {
        if let context = viewController as? NavigationControllerAppearanceContext,
            viewController == topViewController && transitionCoordinator == nil {
            setNavigationBarHidden(context.prefersBarHidden(for: self), animated: true)
            setToolbarHidden(context.prefersToolbarHidden(for: self), animated: true)
            applyAppearance(appearance: context.preferredAppearance(for: self), animated: true)
        }
    }
    
    public func updateAppearance() {
        if let top = topViewController {
            updateAppearance(for: top)
        }
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        appliedAppearance?.statusBarStyle ?? super.preferredStatusBarStyle
    }
    
    public override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        appliedAppearance != nil ? .fade : super.preferredStatusBarUpdateAnimation
    }
}
