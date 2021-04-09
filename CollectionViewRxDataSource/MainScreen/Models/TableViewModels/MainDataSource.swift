//
//  MainDataSource.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import Foundation
import RxCocoa
import RxDataSources

struct MainDataSource {
    typealias DataSource = RxTableViewSectionedReloadDataSource
    
    static func dataSource() -> DataSource<TableViewSection> {
        return .init (configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            
            switch dataSource[indexPath] {
            case let .GridTableViewItem(items):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "GridCell", for: indexPath) as? GridViewCell else { fatalError() }
                if let images = items as? [Character] {
                    cell.viewModel = ImageGridViewModel(characters: images)
                } else if let comicsTitle = items as? [Comics] {
                    cell.viewModel = ComicsGridViewModel(comics: comicsTitle)
                } else {fatalError("Unknown title")}
                
                return cell
            
            case let .TableViewCellItem(items):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CreatorViewCell", for: indexPath) as? CreatorViewCell else { fatalError() }
                cell.creator = items
                return cell
            }
        })
    }
}
