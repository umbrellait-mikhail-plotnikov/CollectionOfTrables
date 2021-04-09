//
//  TableViewModels.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import Foundation
import RxDataSources

enum TableViewSection {
    case GridSection(items: [TableViewItem])
    case CustomSection(items: [TableViewItem])
}

extension TableViewSection: SectionModelType {
    var items: [TableViewItem] {
        switch self {
        case .GridSection(items: let items):
            return items
        case .CustomSection(items: let items):
            return items
        }
    }
    
    var header: String {
        switch self {
        case .GridSection:
            return "Grind Section"
        case .CustomSection:
            return "Custom Section"
        }
    }
    
    typealias Item = TableViewItem
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
