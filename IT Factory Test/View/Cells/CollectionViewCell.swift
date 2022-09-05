
import UIKit

protocol SelfConfiguringCell {
    static var identifier: String { get }
    func configure(with item: Item)
}

class CollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let identifier = "CollectionViewCell"
    
    var sections = ViewController.sections
    private let title = UILabel(textColor: #colorLiteral(red: 0.205396682, green: 0.2254426181, blue: 0.3813610077, alpha: 1), font: .boldSystemFont(ofSize: 17), cornerRadius: 0, textAlignment: .center)
    private var image = UIImageView(contentMode: .scaleAspectFill, cornerRadius: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.translatesAutoresizingMaskIntoConstraints = false
        image.frame = contentView.bounds

        let stackView = UIStackView(arrangedSubviews: [image, title])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        layer.backgroundColor = #colorLiteral(red: 0.5670369267, green: 0.8727459311, blue: 0.6660459638, alpha: 1).cgColor
        layer.cornerRadius = 15
        layer.shadowColor = #colorLiteral(red: 0.3880472779, green: 0.6039398909, blue: 0.4619669318, alpha: 1)
        layer.shadowOffset = .zero
        layer.shadowOpacity = 2
        layer.shadowRadius = 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("stop")
    }
    
    func configure(with item: Item) {
        title.text = item.title
        image.image = UIImage(named: item.image.the1X)
    }
}
