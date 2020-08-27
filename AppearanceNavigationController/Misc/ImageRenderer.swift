
import Foundation
import UIKit

class ImageRenderer: NSObject {
    
    class func renderImageOfColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContext(size)
        
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
