//
//  MarvelAPIProvider.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//

import Foundation
import RxSwift
import RxAlamofire
import ObjectMapper
import CryptoKit

struct APIKey {
    let publicKey: String!
    let privateKey: String!
}

final class MarvelAPIProvider: APIProviderProtocol {
    
    static let shared = MarvelAPIProvider()
    
    private var keys: APIKey?
    private let marvelBaseURL = "https://gateway.marvel.com/v1/public"
    
    public func getCharacters(limit: Int, offset: Int) -> Observable<MarvelCharacters> {
        
        let subPath = "/characters"
        let marvelURL = generateURL(subPath: subPath, limit: limit, offset: offset)
        
        return makeRequest(url: marvelURL)
    }
    
    public func getComics(limit: Int, offset: Int) -> Observable<MarvelComics> {

        let subPath = "/comics"
        let marvelURL = generateURL(subPath: subPath, limit: limit, offset: offset)
        
        return makeRequest(url: marvelURL)
    }
    
    public func getCreators(limit: Int, offset: Int) -> Observable<MarvelCreators> {
        
        let subPath = "/creators"
        let marvelURL = generateURL(subPath: subPath, limit: limit, offset: offset)
        
        return makeRequest(url: marvelURL)
    }
    
    private func getKeys() -> APIKey {
        guard let keys = self.keys else {
//            Read from plist
            guard let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
                  let dict = NSDictionary(contentsOfFile: path)
            else {fatalError("Need correct keys.plist")}
            
            guard let publicKey = dict["publicKey"] as? String,
                  let privateKey = dict["privateKey"] as? String
            else {fatalError("publicKey or privateKey not found")}
            
            let keys = APIKey(publicKey: publicKey, privateKey: privateKey)
            self.keys = keys
            
            return keys
        }
//        Read from param
        return keys
    }
    
    private func makeBaseURL(url: String) -> URLComponents {
        let ts = Date().timeIntervalSince1970.description
        let keys = getKeys()
        let hash = (ts + keys.privateKey + keys.publicKey).md5().dropFirst(12).description
        var marvelURLComponents = URLComponents(string: url)!
        marvelURLComponents.queryItems = [
            URLQueryItem(name: "apikey", value: keys.publicKey),
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "hash", value: hash)
            ]
        return marvelURLComponents
    }
    
    private func generateURL(subPath: String, limit: Int, offset: Int) -> URL {
        let finalStringURL = marvelBaseURL + subPath
        
        var marvelURLComponents = makeBaseURL(url: finalStringURL)
        
        marvelURLComponents.queryItems?.append(contentsOf: [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ])
        guard let url = try? marvelURLComponents.asURL() else { fatalError("Wrong URL") }
        
        return url
    }

    private func makeRequest<T: MarvelModel & BaseMappable>(url: URL) -> Observable<T> {
        return request(.get, url)
            .responseJSON()
            .retry(5)
            .map {
                guard let mappedResponse = Mapper<T>().map(JSONObject: $0.value) else { fatalError("Wrong model") }
                return mappedResponse
            }
    }
}
