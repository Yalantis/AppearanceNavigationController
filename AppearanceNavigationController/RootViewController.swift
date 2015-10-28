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
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! // fine for sample app
        cell.textLabel?.text = "Sample #\(indexPath.row + 1)"
        return cell
    }
    
    // mark: - AppearanceNavigationControllerContent
    
    func preferredNavigationControllerAppearance(navigationController: AppearanceNavigationController) -> Appearance? {
        return Appearance.lightAppearance
    }
    
    // mark: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let
            cell = sender as? UITableViewCell,
            target = segue.destinationViewController as? ContentViewController,
            index = tableView.indexPathForCell(cell)?.row
        {
            target.appearance = values[index]
        }
    }
}

