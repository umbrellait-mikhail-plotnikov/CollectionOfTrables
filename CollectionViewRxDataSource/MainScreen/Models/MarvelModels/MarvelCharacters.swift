//
//  MarvelModels.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//

import Foundation
import ObjectMapper

struct Thumbnail {
    var path: String
    var ext: String
    
    func toString() -> String {
        return "\(path).\(ext)"
    }
}

struct Character {
    let name: String
    let thumbnail: Thumbnail
}

struct MarvelCharacters: Mappable, MarvelModel {
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        results <- map["data.results"]
    }
    
    var characters: [Character] = []
    
    private var results: [[String: Any]]? {
        didSet {
            guard let results = results else {return}
            for result in results {
                guard let name = result["name"] as? String,
                      let temp = result["thumbnail"] as? [String: String],
                      let path = temp["path"],
                      let ext = temp["extension"] else {fatalError()}
                
                let thumbnail = Thumbnail(path: path, ext: ext)
                let character = Character(name: name, thumbnail: thumbnail)
                
                characters.append(character)
            }
        }
    }
}
