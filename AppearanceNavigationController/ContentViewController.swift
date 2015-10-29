//
//  ContentViewController.swift
//  AppearanceNavigationController
//
//  Created by zen on 28/10/15.
//  Copyright © 2015 Zen. All rights reserved.
//

import Foundation
import UIKit

class ContentViewController: UIViewController, AppearanceNavigationControllerContext {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.rightBarButtonItem = editButtonItem()
    }
    
    var appearance: Appearance? {
        didSet {
            setNeedsUpdateNavigationControllerAppearance()
        }
    }
    
    // mark: - Actions
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        setNeedsUpdateNavigationControllerAppearance()
    }
    
    // mark: - AppearanceNavigationControllerContent

    func prefersNavigationControllerToolbarHidden(navigationController: AppearanceNavigationController) -> Bool {
        // hide toolbar during editing
        return editing
    }
    
    func preferredNavigationControllerAppearance(navigationController: AppearanceNavigationController) -> Appearance? {
        // inverse navigation bar color and status bar during editing
        return editing ? appearance?.inversedAppearance : appearance
    }
}