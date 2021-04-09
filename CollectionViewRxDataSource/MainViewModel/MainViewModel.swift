//
//  ViewModel.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//
import UIKit
import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Foundation

class MainViewModel {
    private let api: MarvelAPIProvider
    private let diposedBag = DisposeBag()
    
    private var characters = BehaviorRelay<[Character]>(value: [])
    private var comics = BehaviorRelay<[Comics]>(value: [])
    private var creators = BehaviorRelay<[Creator]>(value: [])
    
    let items = BehaviorRelay<[TableViewSection]>(value: [
        .GridSection(items: []),
        .GridSection(items: []),
        .CustomSection(items: [])
    ])
    
    let dataSource = MainDataSource.dataSource()
    
    func reloadData(closure: @escaping () -> () = {}) {
        characters.accept([])
        comics.accept([])
        creators.accept([])
        getCharcters()
        getCreators()
        getComics()
        closure()
    }
    
    func getCreators(limit: Int = 10, offset: Int? = nil) {
        var newOffset = creators.value.count
        if offset != nil { newOffset = offset! }
        self.api.getCreators(limit: limit, offset: newOffset)
            .map { $0.creators }
            .subscribe(onNext: {
                self.creators.accept(self.creators.value + $0)
            }).disposed(by: diposedBag)
    }
    
    func getCharcters(limit: Int = 25, offset: Int? = nil) {
        var newOffset = creators.value.count
        if offset != nil { newOffset = offset! }
        api.getCharacters(limit: limit, offset: newOffset)
            .map { $0.characters }
            .bind(to: characters)
            .disposed(by: diposedBag)
    }
    
    func getComics(limit: Int = 10, offset: Int? = nil) {
        var newOffset = creators.value.count
        if offset != nil { newOffset = offset! }
        api.getComics(limit: limit, offset: newOffset)
            .map { $0.comics }
            .bind(to: comics)
            .disposed(by: diposedBag)
    }
    
    init(api: MarvelAPIProvider) {
        self.api = api
        
        getCharcters()
        getComics()
        getCreators()
        
        Observable.combineLatest(characters, comics, creators)
            .subscribe(onNext: { (characters, comics, creators) in
                var newValue = self.items.value
                
                var newArray: [TableViewItem] = []
                for i in creators {
                    newArray.append(.TableViewCellItem(items: i))
                }
                
                newValue[0] = .GridSection(items: [.GridTableViewItem(items: characters)])
                newValue[1] = .GridSection(items: [.GridTableViewItem(items: comics)])
                newValue[2] = .CustomSection(items: newArray)
                
                self.items.accept(newValue)
            }).disposed(by: diposedBag) 
    }
}

