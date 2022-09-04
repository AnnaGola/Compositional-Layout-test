
import UIKit

extension UIImageView {
    
    convenience init(contentMode: UIImageView.ContentMode, cornerRadius: CGFloat) {
        self.init()
        self.layer.cornerRadius = cornerRadius
        self.contentMode = contentMode
    }
}
