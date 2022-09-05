
import UIKit

extension UIImageView {
    
    convenience init(contentMode: UIImageView.ContentMode, cornerRadius: CGFloat) {
        self.init()
        self.layer.cornerRadius = cornerRadius
        self.contentMode = contentMode
    }
    
    func loadImage(urlString: String)  {
        guard let url =  URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, respones, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
                print(data)
            }
        }.resume()
    }
}

extension UIView {
    var viewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
