
import UIKit

class RootViewController: UITableViewController, NavigationControllerAppearanceContext {

    private let values: [Appearance] = (0..<10).map { _ in Appearance.random() }
    
    // mark: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! // fine for sample app
        let appearance = values[indexPath.row]
        
        cell.contentView.backgroundColor = appearance.navigationBar.backgroundColor
        cell.textLabel?.textColor = appearance.navigationBar.tintColor
        cell.textLabel?.text = "Sample #\(indexPath.row + 1)"
        cell.textLabel?.backgroundColor = UIColor.clearColor()
     
        return cell
    }
    
    // mark: - AppearanceNavigationControllerContext
    
    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
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

