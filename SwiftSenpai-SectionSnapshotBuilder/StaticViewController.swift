//
//  StaticViewController.swift
//  SwiftSenpai-SectionSnapshotBuilder
//
//  Created by Kah Seng Lee on 26/03/2021.
//

import UIKit

class StaticViewController: UIViewController {

    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ListItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, ListItem>!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Create list layout for collection view
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        
        // Make collection view take up the entire view
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
        
        // Cell registration
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItem> { (cell, indexPath, item) in
            
            var content = cell.defaultContentConfiguration()
            content.image = item.image
            content.text = item.title
            
            cell.contentConfiguration = content
        }
        
        // Configure data source
        dataSource = UICollectionViewDiffableDataSource<Section, ListItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ListItem) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: identifier)
            
            return cell
        }
        
        let sectionSnapshot = multiLevelSectionSnapshot()
        dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
        
    }
}

    @SectionSnapshotBuilder func multiLevelSectionSnapshot()
    -> NSDiffableDataSourceSectionSnapshot<ListItem> {
        
        ListItem("Cell 1")
        ListItem("Cell 2")
        ListItem("Cell 3")
        
        B.parent(ListItem("Cell 4")) {
            
            ListItem("a.circle")
            ListItem("b.square")
            
            B.parent(ListItem("Cell 5")) {
                ListItem("c.circle.fill")
            }
        }
    }

@SectionSnapshotBuilder func singleLevelSectionSnapshot() -> NSDiffableDataSourceSectionSnapshot<ListItem> {
    
    ListItem("Cell 1")
    ListItem("Cell 2")
    ListItem("Cell 3")
    ListItem("paperplane.fill")
    ListItem("doc.text")
    ListItem("book.fill")
}
