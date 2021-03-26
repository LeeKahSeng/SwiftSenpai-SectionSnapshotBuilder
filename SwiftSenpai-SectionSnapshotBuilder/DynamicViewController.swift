//
//  DynamicViewController.swift
//  SwiftSenpai-SectionSnapshotBuilder
//
//  Created by Kah Seng Lee on 26/03/2021.
//

import UIKit

class DynamicViewController: UIViewController {

    enum Section {
        case main
    }
    
    enum Order {
        case descending
        case ascending
        
        var title: String {
            switch self {
            case .descending:
                return "Descending"
            case .ascending:
                return "Ascending"
            }
        }
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, ListItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, ListItem>!
    
    var orderButton: UIBarButtonItem!
    var currentOrder = Order.ascending {
        didSet {
            switch currentOrder {
            case .descending:
                orderButton.title = Order.ascending.title
            case .ascending:
                orderButton.title = Order.descending.title
            }
        }
    }
    
    let symbolNames = [
        "a.circle",
        "a.circle.fill",
        "a.square",
        "a.square.fill",
        
        "b.circle",
        "b.circle.fill",
        "b.square",
        "b.square.fill",
        
        "c.circle",
        "c.circle.fill",
        "c.square",
        "c.square.fill",
    ]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        orderButton = UIBarButtonItem(title: Order.descending.title, primaryAction: UIAction(handler: { [unowned self] _ in
            
            switch self.currentOrder {
            case .descending:
                // Change to ascending
                let sectionSnapshot = generateSectionSnapshot(for: symbolNames, descending: false)
                dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
                currentOrder = .ascending
            case .ascending:
                // Change to descending
                let sectionSnapshot = generateSectionSnapshot(for: symbolNames, descending: true)
                dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
                currentOrder = .descending
            }
            
        }), menu: nil)
        
        navigationItem.rightBarButtonItem = orderButton
        
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
        
        let sectionSnapshot = generateSectionSnapshot(for: symbolNames, descending: false)
        dataSource.apply(sectionSnapshot, to: .main, animatingDifferences: false)
    }

}

typealias B = SectionSnapshotBuilder
@SectionSnapshotBuilder func generateSectionSnapshot(for symbolNames: [String], descending: Bool) -> NSDiffableDataSourceSectionSnapshot<ListItem> {
    
    B.parent(ListItem("Circle")) {
        
        B.parent(ListItem("Fill (Circle)")) {
            
            // Find all filled circle symbols and transform them to `ListItem`
            let circleFillSymbols = symbolNames.filter {
                $0.contains("circle.fill")
            }.map {
                ListItem($0)
            }
            
            // Make all filled circle symbols as child of `ListItem("Fill (Circle)")`
            if descending {
                Array(circleFillSymbols.reversed())
            } else {
                circleFillSymbols
            }
        }
        
        B.parent(ListItem("No Fill (Circle)")) {
            
            // Find all unfilled circle symbols and transform them to `ListItem`
            let circleNoFillSymbols = symbolNames.filter {
                $0.contains("circle") && !$0.contains("fill")
            }.map {
                ListItem($0)
            }
            
            // Make all unfilled circle symbols as child of `ListItem("No Fill (Circle)")`
            if descending {
                Array(circleNoFillSymbols.reversed())
            } else {
                circleNoFillSymbols
            }
        }
    }
    
    B.parent(ListItem("Square")) {
        
        B.parent(ListItem("Fill (Square)")) {
            
            // Find all filled square symbols and transform them to `ListItem`
            let squareFillSymbols = symbolNames.filter {
                $0.contains("square.fill")
            }.map {
                ListItem($0)
            }
            
            // Make all filled square symbols as child of `ListItem("Fill (Square)")`
            if descending {
                Array(squareFillSymbols.reversed())
            } else {
                squareFillSymbols
            }
        }
        
        B.parent(ListItem("No Fill (Square)")) {
            
            // Find all unfilled square symbols and transform them to `ListItem`
            let squareNoFillSymbols = symbolNames.filter {
                $0.contains("square") && !$0.contains("fill")
            }.map {
                ListItem($0)
            }
            
            // Make all unfilled square symbols as child of `ListItem("No Fill (Square)")`
            if descending {
                Array(squareNoFillSymbols.reversed())
            } else {
                squareNoFillSymbols
            }
        }
    }
}
