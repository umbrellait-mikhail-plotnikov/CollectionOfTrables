//
//  MarvelModels.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//

import Foundation
import ObjectMapper

struct MarvelCharacters: Mappable, MarvelModel {
    
    struct Thumbnail {
        var path: String!
        var ext: String!
    }
    
    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        results <- map["data.results"]
    }
    
    var names = [String]()
    var thumbnails = [Thumbnail]()
    
    var results: [[String: Any]]? {
        didSet {
            guard let results = results else {return}
            names = []
            thumbnails = []
            for result in results {
                guard let name = result["name"] as? String,
                      let temp = result["thumbnail"] as? [String: String],
                      let path = temp["path"],
                      let ext = temp["extension"] else {fatalError()}
                
                let thumbnail = Thumbnail(path: path, ext: ext)
                
                names.append(name)
                thumbnails.append(thumbnail)
            }
            print(names)
            print(thumbnails)
        }
    }
}
