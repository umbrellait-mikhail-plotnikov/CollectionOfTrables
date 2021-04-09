//
//  APIProviderProtocol.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//
import RxSwift
import Foundation

protocol APIProviderProtocol: class {
    func getCharacters(limit: Int, offset: Int) -> Observable<MarvelCharacters>
    func getComics(limit: Int, offset: Int) -> Observable<MarvelComics>
    func getCreators(limit: Int, offset: Int) -> Observable<MarvelCreators>
}
