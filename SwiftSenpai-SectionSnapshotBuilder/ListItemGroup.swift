//
//  ListItemGroup.swift
//  SwiftSenpai-SectionSnapshotBuilder
//
//  Created by Kah Seng Lee on 21/03/2021.
//

import Foundation

protocol ListItemGroup {
    var items: [ListItem] { get }
}

extension Array: ListItemGroup where Element == ListItem {
    var items: [ListItem] { self }
}

extension ListItem: ListItemGroup {
    var items: [ListItem] { [self] }
}
