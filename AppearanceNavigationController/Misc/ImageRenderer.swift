
import Foundation
import UIKit

class ImageRenderer: NSObject {

    class func renderImageOfColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext();
        
        context?.setFillColor(color.cgColor);
        context?.fill(CGRect(x:0, y:0, width: size.width, height: size.height));
        
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return output!;
    }
}
