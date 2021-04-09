//
//  GridViewModelProtocol.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import Foundation
import RxCocoa
import RxDataSources

protocol GridViewModelProtocol {
    func getNewItems(limit: Int, closure: @escaping () -> ()) 
    var data: BehaviorRelay<[Any]> {get}
    
}
