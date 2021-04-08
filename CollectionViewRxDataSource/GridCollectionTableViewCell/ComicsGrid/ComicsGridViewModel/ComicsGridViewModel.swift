//
//  ComicsGridViewModel.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import Foundation
import RxCocoa
import RxSwift

struct ComicsGridViewModel: GridViewModelProtocol {
    
    private let disposedBag = DisposeBag()
    
    func getNewItems(limit: Int) {
        MarvelAPIProvider.shared.getComics(limit: 15, offset: data.value.count)
            .map { $0.comics }
            .subscribe(onNext: {
                self.data.accept(self.data.value + $0)
            }).disposed(by: disposedBag)
    }
    
    let data = BehaviorRelay<[Any]>(value: [])
    
    init(comics: [Comics]) {
        self.data.accept(comics)
    }
}
