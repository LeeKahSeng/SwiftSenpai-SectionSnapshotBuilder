//
//  ListItem.swift
//  SwiftSenpai-SectionSnapshotBuilder
//
//  Created by Kah Seng Lee on 21/03/2021.
//

import Foundation
import UIKit

struct ListItem: Hashable {

    let title: String
    let image: UIImage?
    var children: [ListItem]

    init(_ title: String, children: [ListItem] = []) {
        self.title = title
        self.image = UIImage(systemName: title)
        self.children = children
    }
}
