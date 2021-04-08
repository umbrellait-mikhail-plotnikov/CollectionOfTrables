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
        .GridSection(items: [
        ]),
        .GridSection(items: [
        ]),
        .CustomSection(items: [
        ])
    ])
    
    let dataSource = MainDataSource.dataSource()
    
    func getCreators(limit: Int) {
        self.api.getCreators(limit: 10, offset: creators.value.count)
            .map { $0.creators }
            .subscribe(onNext: {
                self.creators.accept(self.creators.value + $0)
            }).disposed(by: diposedBag)
    }
    
    init(api: MarvelAPIProvider) {
        self.api = api
        
        api.getCharacters(limit: 50, offset: characters.value.count)
            .map { $0.characters }
            .bind(to: characters)
            .disposed(by: diposedBag)
            
        api.getCreators(limit: 10, offset: creators.value.count)
            .map { $0.creators }
            .bind(to: creators)
            .disposed(by: diposedBag)
        
        api.getComics(limit: 50, offset: comics.value.count)
            .map { $0.comics }
            .bind(to: comics)
            .disposed(by: diposedBag)
        
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

