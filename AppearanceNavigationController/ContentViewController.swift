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
    
    var appearance: Appearance? {
        didSet {
            setNeedsUpdateNavigationControllerAppearance()
        }
    }
    
    // mark: - Actions
    
    
    
    // mark: - AppearanceNavigationControllerContent

    func prefersNavigationControllerToolbarHidden(navigationController: AppearanceNavigationController) -> Bool {
        return editing
    }
    
    func preferredNavigationControllerAppearance(navigationController: AppearanceNavigationController) -> Appearance? {
        return editing ? appearance?.inversedAppearance : appearance
    }
}