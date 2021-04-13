//
//  MarvelService.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 13.04.2021.
//

import Foundation
import Moya
import Moya_ObjectMapper
import RxSwift

final class MarvelService {
    
    static let shared = MarvelService()
    
    private let api = MoyaProvider<MarvelAPI>()
    private var keys: MarvelAPIKey?
    
    func getKeys() -> MarvelAPIKey {
        guard let keys = self.keys else {
//            Read from plist
            guard let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
                  let dict = NSDictionary(contentsOfFile: path)
            else {fatalError("Need correct keys.plist")}
            
            guard let publicKey = dict["publicKey"] as? String,
                  let privateKey = dict["privateKey"] as? String
            else {fatalError("publicKey or privateKey not found")}
            
            let keys = MarvelAPIKey(publicKey: publicKey, privateKey: privateKey)
            self.keys = keys
            
            return keys
        }
//        Read from param
        return keys
    }
    
}

extension MarvelService: MarvelAPIProviderProtocol {
    
    func getCharacters(limit: Int, offset: Int) -> Single<MarvelCharacters> {
        return api.rx.request(.getCharacters(limit: limit, offset: offset))
            .filterSuccessfulStatusCodes()
            .mapObject(MarvelCharacters.self)
    }
    
    func getComics(limit: Int, offset: Int) -> Single<MarvelComics> {
        return api.rx.request(.getComics(limit: limit, offset: offset))
            .filterSuccessfulStatusCodes()
            .mapObject(MarvelComics.self)
    }
    
    func getCreators(limit: Int, offset: Int) -> Single<MarvelCreators> {
        return api.rx.request(.getCreators(limit: limit, offset: offset))
            .filterSuccessfulStatusCodes()
            .mapObject(MarvelCreators.self)
    }
    
}


