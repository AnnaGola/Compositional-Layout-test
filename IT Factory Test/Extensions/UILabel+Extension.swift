
import UIKit

extension UILabel {
    
    convenience init(textColor: UIColor, font: UIFont, cornerRadius: CGFloat, numberOfLines: Int = 0, textAlignment: NSTextAlignment) {
        self.init()
        self.textColor = textColor
        self.font = font
        self.layer.cornerRadius = cornerRadius
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
    }
}
