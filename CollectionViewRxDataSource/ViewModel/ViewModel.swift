//
//  ViewModel.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//

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
            .GridTableViewItem(titles: ["Тут", "Будут", "Изображения", "Героев", "(надеюсь)"]),
            .GridTableViewItem(titles: ["Тут", "Будут", "Названия", "Комисков"]),
            .TableViewCellItem(titles: ["1", "2", "3", "4", "5"])
        ])
    ])
    
    let dataSource = MyDataSource.dataSource()
}

enum TableViewItem {
    case GridTableViewItem(titles: [String])
    case TableViewCellItem(titles: [String])
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

struct GridViewModel {
    let titles = BehaviorRelay<[String]>(value: [])
    
    init(titles: [String]) {
        self.titles.accept(titles)
    }
}

struct MyDataSource {
    typealias DataSource = RxTableViewSectionedReloadDataSource
    
    static func dataSource() -> DataSource<TableViewSection> {
        return .init (configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            
            switch dataSource[indexPath] {
            case let .GridTableViewItem(titles):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? HorizontalCollectionTableViewCell else {fatalError()}
                cell.data = GridViewModel(titles: titles)
                return cell
            case let .TableViewCellItem(titles):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as? UITableViewCell else {fatalError()}
                cell.textLabel?.text = titles.first
                return cell
            }
            
        }, titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        })
    }
}
