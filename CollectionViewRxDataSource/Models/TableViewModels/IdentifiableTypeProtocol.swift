//
//  IdentifyProtocol.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import Foundation

protocol IdentifiableType {
    associatedtype Identity: Hashable
    
    var identity: Identity { get }
}
