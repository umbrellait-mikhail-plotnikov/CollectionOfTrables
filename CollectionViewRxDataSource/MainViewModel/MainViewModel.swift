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

struct Creator {
    let name: String
    let thumbnail: Thumbnail
}

class MainViewModel {
    private let api: APIProviderProtocol
    private let diposedBag = DisposeBag()
    
    private var characters = BehaviorRelay<[Thumbnail]>(value: [])
    private var comics = BehaviorRelay<[String]>(value: [])
    private var creators = BehaviorRelay<[Creator]>(value: [])
    
    var items = BehaviorRelay<[TableViewSection]>(value: [
        .GridSection(items: [
            .GridTableViewItem(items: [])
        ]),
        .GridSection(items: [
            .GridTableViewItem(items: [])
        ]),
        .CustomSection(items: [
            .TableViewCellItem(items: Creator(name: "", thumbnail: Thumbnail(path: "", ext: "")))
        ])
    ])
    
    let dataSource = MainDataSource.dataSource()
    
    init(api: MarvelAPIProvider) {
        self.api = api
        api.getCharacters(limit: 10, offset: 0)
            .map { $0.thumbnails }
            .bind(to: characters)
            .disposed(by: diposedBag)
        
        characters.subscribe(onNext: {
            var newArray = [URL?]()
            $0.forEach({ newArray.append(URL(string: $0.toString()))})
            var newValue = self.items.value
            newValue[0] = .GridSection(items: [.GridTableViewItem(items: newArray as [Any])])
            self.items.accept(newValue)
        }).disposed(by: diposedBag)
        
        api.getComics(limit: 10, offset: 0)
            .map { $0.titles }
            .bind(to: comics)
            .disposed(by: diposedBag)
        
        comics.subscribe(onNext: {
            var newValue = self.items.value
            newValue[1] = .GridSection(items: [.GridTableViewItem(items: $0)])
            self.items.accept(newValue)
        }).disposed(by: diposedBag)
        
        api.getCreators(limit: 10, offset: 0)
            .map {
                var newArray = [Creator]()
                for i in 0 ..< $0.fullNames.count {
                    let name = $0.fullNames[i]
                    let thumbnail = $0.thumbnails[i]
                    newArray.append(Creator(name: name, thumbnail: thumbnail))
                }
                return newArray
            }
            .bind(to: creators)
            .disposed(by: diposedBag)
        
        creators.subscribe(onNext: {
            var newArray: [TableViewItem] = []
            for i in $0 {
                newArray.append(.TableViewCellItem(items: i))
            }
            var newValue = self.items.value
            newValue[2] = .CustomSection(items: newArray)
            print(newArray)
            self.items.accept(newValue)
        }).disposed(by: diposedBag)
    }
}

