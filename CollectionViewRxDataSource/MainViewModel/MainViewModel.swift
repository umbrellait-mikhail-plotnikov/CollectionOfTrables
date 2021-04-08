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

class MainViewModel {
    private let api: APIProviderProtocol
    private let diposedBag = DisposeBag()
    
    private var characters = BehaviorRelay<[Thumbnail]>(value: [])
    
    private var comics: BehaviorRelay<MarvelComics>!
    private var creators: BehaviorRelay<MarvelCreators>!
    
    var items = BehaviorRelay<[TableViewSection]>(value: [
//        .GridSection(items: [
//            .GridTableViewItem(items: characters.value),
//            .GridTableViewItem(items: ["Тут", "Будут", "Комиксы", "Про", "Героев"])
//        ]),
//        .CustomSection(items: [
//            .TableViewCellItem(title: "1"),
//            .TableViewCellItem(title: "2"),
//            .TableViewCellItem(title: "3"),
//            .TableViewCellItem(title: "4")
//        ])
    ])
    
    let dataSource = MainDataSource.dataSource()
    
    init(api: MarvelAPIProvider) {
        self.api = api
        api.getCharacters(limit: 10, offset: 0)
            .map {
                print($0.thumbnails)
                return $0.thumbnails }
            .bind(to: characters)
            .disposed(by: diposedBag)
        items.accept([.GridSection(items: [.GridTableViewItem(items: characters.value)])])
//        api.getComics(limit: 10, offset: 0)
//            .bind(to: comics)
//            .disposed(by: diposedBag)
//        api.getCreators(limit: 10, offset: 0)
//            .bind(to: creators)
//            .disposed(by: diposedBag)
    }
}

