//
//  APIProviderProtocol.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//
import RxSwift
import Foundation

protocol MarvelAPIProviderProtocol: class {
    func getCharacters(limit: Int, offset: Int) -> Single<MarvelCharacters>
    func getComics(limit: Int, offset: Int) -> Single<MarvelComics>
    func getCreators(limit: Int, offset: Int) -> Single<MarvelCreators>
}
