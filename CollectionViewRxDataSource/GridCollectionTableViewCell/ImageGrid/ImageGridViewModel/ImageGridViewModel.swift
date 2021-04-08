//
//  GridViewModel.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import Foundation
import RxCocoa
import RxSwift

struct ImageGridViewModel: GridViewModelProtocol {
    
    private let disposedBag = DisposeBag()
    
    func getNewItems(limit: Int) {
        MarvelAPIProvider.shared.getCharacters(limit: 25, offset: data.value.count)
            .map { $0.characters }
            .subscribe(onNext: {
                self.data.accept(self.data.value + $0)
            }).disposed(by: disposedBag)
    }
    
    let data = BehaviorRelay<[Any]>(value: [])
    
    init(characters: [Character]) {
        self.data.accept(characters)
    }
}
