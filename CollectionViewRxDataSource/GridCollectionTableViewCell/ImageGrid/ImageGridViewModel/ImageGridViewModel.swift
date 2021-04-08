//
//  GridViewModel.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import Foundation
import RxCocoa

struct ImageGridViewModel: GridViewModelProtocol {
    let data = BehaviorRelay<[Any]>(value: [])
    
    init(images: [UIImage]) {
        self.data.accept(images)
    }
}
