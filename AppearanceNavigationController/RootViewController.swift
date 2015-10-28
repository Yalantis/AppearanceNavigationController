//
//  ViewController.swift
//  AppearanceNavigationController
//
//  Created by zen on 28/10/15.
//  Copyright © 2015 Zen. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController, AppearanceNavigationControllerContext {

    private let values: [Appearance] = (0..<10).map { _ in Appearance.random() }
    
    // mark: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! // fine for sample app
        let appearance = values[indexPath.row]
        
        cell.contentView.backgroundColor = appearance.navigationBarColor
        cell.textLabel?.textColor = appearance.navigationBarTintColor
        cell.textLabel?.text = "Sample #\(indexPath.row + 1)"
        cell.textLabel?.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    // mark: - AppearanceNavigationControllerContext
    
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

