//
//  ViewModel.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//
import RxSwift
import RxCocoa
import Foundation

class ViewModel {
    var sourcesArray = BehaviorRelay<[String]>(value: [])
    var randomArray = BehaviorRelay<[Int]>(value: [1,2])
    
    func addNewSource(newSource: String) {
        sourcesArray.accept(sourcesArray.value + [newSource])
    }
}
