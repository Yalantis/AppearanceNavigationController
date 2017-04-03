
import UIKit

class RootViewController: UITableViewController, NavigationControllerAppearanceContext {

    fileprivate let values: [Appearance] = (0..<10).map { _ in Appearance.random() }
    
    // mark: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! // fine for sample app
        let appearance = values[indexPath.row]
        
        cell.contentView.backgroundColor = appearance.navigationBar.backgroundColor
        cell.textLabel?.textColor = appearance.navigationBar.tintColor
        cell.textLabel?.text = "Sample #\(indexPath.row + 1)"
        cell.textLabel?.backgroundColor = UIColor.clear
     
        return cell
    }
    
    // mark: - AppearanceNavigationControllerContext
    
    func preferredNavigationControllerAppearance(_ navigationController: UINavigationController) -> Appearance? {
        return Appearance.lightAppearance
    }
    
    // mark: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let
            cell = sender as? UITableViewCell,
            let target = segue.destination as? ContentViewController,
            let index = tableView.indexPath(for: cell)?.row
        {
            target.appearance = values[index]
        }
    }
}

