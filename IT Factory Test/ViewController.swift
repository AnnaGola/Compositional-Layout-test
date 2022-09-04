import UIKit
import Foundation

class ViewController: UIViewController {

    var sections: MainView?
    var collectionView: UICollectionView!

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        registerCollectionViewCells()
        setupDataSource()
        reloadData()
        parseJSONSections()
    }
    
    func parseJSONSections() {
        guard let path = Bundle.main.path(forResource: "jsonviewer", ofType: "json") else { return }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let jsonData = try Data(contentsOf: url)
            sections = try JSONDecoder().decode(MainView.self, from: jsonData)
            print(sections?.sections[0])
        } catch {
            print("Fatal error \(error)")
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    fileprivate func  registerCollectionViewCells() {
        collectionView.register(HeaderSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSection.identifier)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        collectionView.dataSource = self.dataSource
        reloadData()
    }
    
    func configure<Cell: SelfConfiguringCell>(_ cellType: Cell.Type, with item: Item, for indexPath: IndexPath) -> Cell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? Cell else { fatalError() }
        
        cell.configure(with: item)
        return cell
    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            
            switch self?.sections?.sections[indexPath.row].items {
            default:
                return self?.configure(CollectionViewCell.self, with: item, for: indexPath)
            }
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let headerInSection = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSection.identifier, for: indexPath) as? HeaderSection else {
                return nil
            }
            
            guard let firstItem = self?.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: firstItem) else { return nil }
            headerInSection.title.text = section.header
            
            return headerInSection
        }
    }
    
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections?.sections ?? [])
        
        sections?.sections.forEach { section in
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) in
            let section = self.sections?.sections[sectionIndex]
            
            switch section?.header {
            default:
                return self.createSectionsLayout(of: section!)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    func createSectionsLayout(of section: Section) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(170),
                                               heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                        subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16,
                                                        leading: 16,
                                                        bottom: 0,
                                                        trailing: 16)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.90), heightDimension: .estimated(80))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
}


