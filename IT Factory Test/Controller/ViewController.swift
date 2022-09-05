
import UIKit
import Foundation

class ViewController: UIViewController {
    
    var selectedIndexPath: IndexPath?
    var sections = Bundle.main.decode([Section].self, from: "jsonviewer.json")
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        registerCollectionViewCells()
        setupDataSource()
        reloadData()
        collectionView.delegate = self
    }

    fileprivate func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
    }
    
    fileprivate func  registerCollectionViewCells() {
        collectionView.register(HeaderSection.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSection.identifier)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
}
    
    // MARK: - Extension
extension ViewController {
    
    func configure<Cell: SelfConfiguringCell>(_ cellType: Cell.Type, with item: Item, for indexPath: IndexPath) -> Cell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? Cell else { fatalError() }
        
        cell.configure(with: item)
        return cell
    }
    
    // MARK: - Data Source
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            
            switch self.sections[indexPath.section].id {
            default:
               return self.configure(CollectionViewCell.self, with: item, for: indexPath)
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
        snapshot.appendSections(sections)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        
        dataSource?.apply(snapshot)
    }
    
    // MARK: - Layout
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) in
            let section = self.sections[sectionIndex]
            
            switch section.id {
            default:
                return self.createSectionsLayout(of: section)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
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
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.90), heightDimension: .estimated(80))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedItem = sections[indexPath.item]
//        print(selectedItem)
//    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)

        cell?.layer.backgroundColor = UIColor.black.cgColor

        self.selectedIndexPath = indexPath
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)

        cell?.layer.backgroundColor = UIColor.white.cgColor

        self.selectedIndexPath = nil
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 10

         if self.selectedIndexPath != nil && indexPath == self.selectedIndexPath {
             cell.layer.backgroundColor = UIColor.black.cgColor
         } else {
             cell.layer.backgroundColor = UIColor.white.cgColor
         }
        return cell
    }
}
