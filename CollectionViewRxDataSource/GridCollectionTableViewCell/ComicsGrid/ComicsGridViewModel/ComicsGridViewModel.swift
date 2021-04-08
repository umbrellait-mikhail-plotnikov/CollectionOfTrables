//
//  ComicsGridViewModel.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import Foundation
import RxCocoa

struct ComicsGridViewModel: GridViewModelProtocol {
    let data = BehaviorRelay<[Any]>(value: [])
    
    init(comicsTitle: [String]) {
        self.data.accept(comicsTitle)
    }
}
