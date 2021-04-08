//
//  ViewModel.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//
import UIKit
import Foundation
import ObjectMapper
import RxSwift
import RxCocoa
import RxDataSources
import Foundation

protocol IdentifiableType {
    associatedtype Identity: Hashable
    
    var identity: Identity { get }
}

class ViewModel {
    let diposedBag = DisposeBag()
    
    var items = BehaviorRelay<[TableViewSection]>(value: [
        .GridSection(items: [
            .GridTableViewItem(items: ["Тут", "Будут", "Комиксы", "Про", "Героев"]),
            .GridTableViewItem(items: [UIImage(), UIImage(), UIImage(), UIImage()]),
            .TableViewCellItem(title: "1"),
            .TableViewCellItem(title: "2"),
            .TableViewCellItem(title: "3"),
            .TableViewCellItem(title: "4")
        ])
    ])
    
    let dataSource = MyDataSource.dataSource()
}

enum TableViewItem {
    case GridTableViewItem(items: [Any])
    case TableViewCellItem(title: String)
}

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

struct MyDataSource {
    typealias DataSource = RxTableViewSectionedReloadDataSource
    
    static func dataSource() -> DataSource<TableViewSection> {
        return .init (configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            
            switch dataSource[indexPath] {
            case let .GridTableViewItem(items):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "GridCell", for: indexPath) as? GridViewCell else { fatalError() }
                if let images = items as? [UIImage] {
                    cell.viewModel = ImageGridViewModel(images: images)
                } else if let comicsTitle = items as? [String] {
                    cell.viewModel = ComicsGridViewModel(comicsTitle: comicsTitle)
                } else {fatalError("Unknown title")}
                
                return cell
            
            case let .TableViewCellItem(title):
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = title
                return cell
            }
        })
    }
}
