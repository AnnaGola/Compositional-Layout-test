
import UIKit

class HeaderSection: UICollectionReusableView {
        
    static let identifier = "HeaderSection"
    
    let title = UILabel(textColor: #colorLiteral(red: 0.1714912653, green: 0.1865046322, blue: 0.3150256872, alpha: 1), font: .boldSystemFont(ofSize: 26), cornerRadius: 0, textAlignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.trailingAnchor.constraint(equalTo: trailingAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
