
import UIKit

protocol SelfConfiguringCell {
    static var identifier: String { get }
    func configure(with item: Item)
}

class CollectionViewCell: UICollectionViewCell, SelfConfiguringCell, UICollectionViewDelegate {
    
    static let identifier = "CollectionViewCell"
    
    private let title = UILabel(textColor: #colorLiteral(red: 0.205396682, green: 0.2254426181, blue: 0.3813610077, alpha: 1), font: .boldSystemFont(ofSize: 15), cornerRadius: 0, textAlignment: .center)
    private var imageView = UIImageView(contentMode: .scaleAspectFit, cornerRadius: 15)
    private var collectionView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView?.delegate = self
        collectionView?.reloadData()

        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.layer.cornerRadius = 15
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = .zero
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowRadius = 10
        
        let stackView = UIStackView(arrangedSubviews: [imageView, title])
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
        
        let path = item.image.the1X
        imageView.image = UIImage(contentsOfFile: path)
    }
//
//    override var isSelected: Bool {
//        didSet {
//            if self.isSelected {
//                UIView.animate(withDuration: 0.3) {
//                     self.backgroundColor = UIColor(red: 115/255, green: 190/255, blue: 170/255, alpha: 1.0)
//                }
//            }
//        }
//    }
//
//    func showAlert() {
//        let alert = UIAlertController(title: "Stop", message: "Selected 6 items", preferredStyle: .alert)
//        let action = UIAlertAction(title: "cencel", style: .cancel)
//        alert.addAction(action)
//        guard let parentController = viewController else { return }
//        parentController.present(alert, animated: true)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
//        cell?.layer.borderWidth = 20
//        cell?.layer.borderColor = UIColor.gray.cgColor
//    }
}
