//
//  File.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 09.04.2021.
//

import Foundation
import Moya

enum MarvelAPI {
    case getCharacters(limit: Int, offset: Int)
    case getComics(limit: Int, offset: Int)
    case getCreators(limit: Int, offset: Int)
}

extension MarvelAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://gateway.marvel.com/v1/public")!
    }
    
    var path: String {
        switch self {
        case .getCharacters:
            return "/characters"
        case .getComics:
            return "/comics"
        case .getCreators:
            return "/creators"
        default:
            fatalError("Unknown case")
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        let keys = MarvelService.shared.getKeys()
        let ts = Date().timeIntervalSince1970.description
        let hash = (ts + keys.privateKey + keys.publicKey).md5().dropFirst(12).description
    
        switch self {
        case .getCharacters(let limit, let offset):
            return .requestParameters(
                parameters: configureRequest(limit: limit, offset: offset, keys: keys, ts: ts, hash: hash),
                encoding: URLEncoding.default)
        
        case .getComics(let limit, let offset):
            return .requestParameters(
                parameters: configureRequest(limit: limit, offset: offset, keys: keys, ts: ts, hash: hash),
                encoding: URLEncoding.default)
        
        case .getCreators(let limit, let offset):
            return .requestParameters(
                parameters: configureRequest(limit: limit, offset: offset, keys: keys, ts: ts, hash: hash),
                encoding: URLEncoding.default)
            
        default:
            fatalError("Unknown case")
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    private func configureRequest(limit: Int, offset: Int, keys: MarvelAPIKey, ts: String, hash: String) -> [String: Any] {
            return [
                "limit": limit,
                "offset": offset,
                "apikey": keys.publicKey!,
                "ts": ts,
                "hash": hash
                ]
    }
}
