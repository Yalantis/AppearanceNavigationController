//
//  ViewController.swift
//  AppearanceNavigationController
//
//  Created by zen on 28/10/15.
//  Copyright © 2015 Zen. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    private let schemes: [AppearanceScheme] = (0..<10).map { _ in AppearanceScheme.randomScheme() }
    
    // mark: - UITableViewDataSource
    
    public func preferredNavigationControllerAppearanceScheme(navigationController: AppearanceNavigationController) -> AppearanceScheme? {
        return nil
    }
}

