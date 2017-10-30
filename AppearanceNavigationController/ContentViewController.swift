
import Foundation
import UIKit

class ContentViewController: UIViewController, NavigationControllerAppearanceContext {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    var appearance: Appearance? {
        didSet {
            setNeedsUpdateNavigationControllerAppearance()
        }
    }
    
    // mark: - Actions
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        setNeedsUpdateNavigationControllerAppearance()
    }
    
    // mark: - AppearanceNavigationControllerContent

    func prefersNavigationControllerToolbarHidden(_ navigationController: UINavigationController) -> Bool {
        // hide toolbar during editing
        return isEditing
    }
    
    func preferredNavigationControllerAppearance(_ navigationController: UINavigationController) -> Appearance? {
        // inverse navigation bar color and status bar during editing
        return isEditing ? appearance?.inverse() : appearance
    }
}
