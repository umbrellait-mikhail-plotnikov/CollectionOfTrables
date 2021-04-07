//
//  MarvelCreators.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//

import Foundation
import ObjectMapper

struct MarvelCreators: Mappable, MarvelModel {
    
    struct Thumbnail {
        var path: String!
        var ext: String!
    }
    
    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        results <- map["data.results"]
    }
    
    var fullNames = [String]()
    var thumbnails = [Thumbnail]()
    
    var results: [[String: Any]]? {
        didSet {
            guard let results = results else {return}
            fullNames = []
            thumbnails = []
            for result in results {
                guard let fullName = result["fullName"] as? String,
                      let temp = result["thumbnail"] as? [String: String],
                      let path = temp["path"],
                      let ext = temp["extension"] else {fatalError()}
                
                let thumbnail = Thumbnail(path: path, ext: ext)
                
                fullNames.append(fullName)
                thumbnails.append(thumbnail)
            }
            print(fullNames)
            print(thumbnails)
        }
    }
}
