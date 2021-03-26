//
//  SectionSnapshotBuilder.swift
//  SwiftSenpai-SectionSnapshotBuilder
//
//  Created by Kah Seng Lee on 21/03/2021.
//

import Foundation
import UIKit

@resultBuilder
struct SectionSnapshotBuilder {
    
    static func buildBlock(_ components: ListItemGroup...) -> [ListItem] {
        return components.flatMap { $0.items }
    }

    static func buildArray(_ components: [ListItemGroup]) -> [ListItem] {
        return components.flatMap { $0.items }
    }

    static func buildOptional(_ component: [ListItemGroup]?) -> [ListItem] {
        return component?.flatMap { $0.items } ?? []
    }

    static func buildEither(first component: [ListItemGroup]) -> [ListItem] {
        return component.flatMap { $0.items }
    }

    static func buildEither(second component: [ListItemGroup]) -> [ListItem] {
        return component.flatMap { $0.items }
    }
    
    static func buildFinalResult(_ component: [ListItem]) -> [ListItem] {
        return component
    }
    
    static func buildFinalResult(_ component: [ListItem]) -> NSDiffableDataSourceSectionSnapshot<ListItem> {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<ListItem>()
        createSection(nil, with: component, for: &sectionSnapshot)
        return sectionSnapshot
    }
    
    static func parent(_ parent: ListItem,
                       @SectionSnapshotBuilder children: () -> [ListItem]) -> ListItem {
        return ListItem(parent.title, children: children())
    }
    
    private static func createSection(_ parent: ListItem?,
                                      with children: [ListItem],
                                      for sectionSnapshot: inout NSDiffableDataSourceSectionSnapshot<ListItem>) {
        
        for child in children {

            if child.children.count > 0 {
                // Children available

                if parent == nil {
                    // Append first level items with children
                    sectionSnapshot.append([child])
                }
                sectionSnapshot.expand([child])
                sectionSnapshot.append(child.children, to: child)
                
                createSection(child, with: child.children, for: &sectionSnapshot)
                
            } else if parent == nil {
                // Append first level items without children
                sectionSnapshot.append([child])
            }
        }
    }
}
