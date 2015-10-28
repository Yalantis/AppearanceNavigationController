//
//  ViewController.swift
//  AppearanceNavigationController
//
//  Created by zen on 28/10/15.
//  Copyright © 2015 Zen. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController, AppearanceNavigationControllerContent {

    private let values: [Appearance] = (0..<10).map { _ in Appearance.random() }
    
    // mark: - UITableViewDataSource
    
    func preferredNavigationControllerAppearance(navigationController: AppearanceNavigationController) -> Appearance? {
        return Appearance.lightAppearance
    }
}

