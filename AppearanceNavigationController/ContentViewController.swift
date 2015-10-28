//
//  ContentViewController.swift
//  AppearanceNavigationController
//
//  Created by zen on 28/10/15.
//  Copyright © 2015 Zen. All rights reserved.
//

import Foundation
import UIKit

class ContentViewController: UIViewController, AppearanceNavigationControllerContent {
    
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
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // mark: - AppearanceNavigationControllerContent

    func prefersNavigationControllerToolbarHidden(navigationController: AppearanceNavigationController) -> Bool {
        return editing
    }
    
    func preferredNavigationControllerAppearance(navigationController: AppearanceNavigationController) -> Appearance? {
        return editing ? appearance?.inversedAppearance : appearance
    }
}