//
//  ComicsGridViewModel.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

struct ComicsSection {
    var header: String
    var items: [Item]
}

extension ComicsSection: SectionModelType {
    typealias Item = Comics
    
    init(original: ComicsSection, items: [Comics]) {
        self = original
        self.items = items
    }
}

struct ComicsGridViewModel: GridViewModelProtocol {
    
    private let disposedBag = DisposeBag()
    private let _comics = BehaviorRelay<[ComicsSection]>(value: [])
    var comics: Driver<[ComicsSection]> {
        return _comics.asDriver()
    }
    
    let data = BehaviorRelay<[Any]>(value: [])
    let dataSource = RxCollectionViewSectionedReloadDataSource<ComicsSection>(configureCell: { dataSource, collectionView, indexPath, element in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicsViewCell", for: indexPath) as! ComicsViewCell
        
        cell.comics = element
        
        return cell
        
    })
    
    func getNewItems(limit: Int, closure: @escaping () -> ()) {
        MarvelAPIProvider.shared.getComics(limit: limit, offset: data.value.count)
            .map { $0.comics }
            .subscribe(onNext: {
                self.data.accept(self.data.value + $0)
                self._comics.accept([ComicsSection(header: "Comics", items: self.data.value as! [Comics])])
                closure()
            }).disposed(by: disposedBag)
    }
    
    init(comics: [Comics]) {
        self.data.accept(comics)
        self._comics.accept([ComicsSection(header: "Comics", items: comics)])
        //self.comics = comics
    }
}
