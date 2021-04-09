//
//  MarvelCreators.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//

import Foundation
import ObjectMapper

struct Creator {
    let name: String
    let thumbnail: Thumbnail
}

struct MarvelCreators: Mappable, MarvelModel {
    
    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        results <- map["data.results"]
    }
    
    var creators: [Creator] = []
    
    private var results: [[String: Any]]? {
        didSet {
            guard let results = results else {return}
            for result in results {
                guard let fullName = result["fullName"] as? String,
                      let temp = result["thumbnail"] as? [String: String],
                      let path = temp["path"],
                      let ext = temp["extension"] else {fatalError()}
                
                let thumbnail = Thumbnail(path: path, ext: ext)
                let creator = Creator(name: fullName, thumbnail: thumbnail)
                creators.append(creator)
            }
        }
    }
}
