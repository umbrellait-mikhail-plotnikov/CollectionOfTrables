//
//  GridViewModelProtocol.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import Foundation
import RxCocoa

protocol GridViewModelProtocol {
    var data: BehaviorRelay<[Any]> {get}
}
