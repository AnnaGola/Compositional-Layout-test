import UIKit

protocol SelfConfiguringCell {
    static var identifier: String { get }
    func configure(with item: Item)
}

class CollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    
    static let identifier = "CollectionViewCell"
    
    private let title = UILabel()
    private var image = UIImageView() {
        didSet {
            image.backgroundColor = .red
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.textColor = .label

        image.layer.cornerRadius = 15
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
        image.image = UIImage(named: item.image.the1X)
    }
}

