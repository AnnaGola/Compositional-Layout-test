
import UIKit

protocol SelfConfiguringCell {
    static var identifier: String { get }
    func configure(with item: Item)
}

class CollectionViewCell: UICollectionViewCell, SelfConfiguringCell, UICollectionViewDelegate {
    
    static let identifier = "CollectionViewCell"
    
    private let title = UILabel(textColor: #colorLiteral(red: 0.1714912653, green: 0.1865046322, blue: 0.3150256872, alpha: 1), font: .boldSystemFont(ofSize: 15), cornerRadius: 0, textAlignment: .center)
    private var image = UIImageView(contentMode: .scaleAspectFill, cornerRadius: 15)
    private var collectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView?.delegate = self

        image.clipsToBounds = true
        image.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let stackView = UIStackView(arrangedSubviews: [image, title])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("stop")
    }
    
    func configure(with item: Item) {
        title.text = item.title
        image.image = UIImage(named: item.image.the2X)
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                UIView.animate(withDuration: 0.3) {
                     self.backgroundColor = UIColor(red: 115/255, green: 190/255, blue: 170/255, alpha: 1.0)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 20
            cell?.layer.borderColor = UIColor.gray.cgColor
    }
}

