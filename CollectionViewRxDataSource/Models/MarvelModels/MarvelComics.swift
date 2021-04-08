//
//  MarvelComics.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//

import Foundation
import ObjectMapper

struct MarvelComics: Mappable, MarvelModel {
    
    init?(map: Map) {
        
    }

    mutating func mapping(map: Map) {
        results <- map["data.results"]
    }
    
    var titles = [String]()
    var thumbnails = [Thumbnail]()
    
    var results: [[String: Any]]? {
        didSet {
            guard let results = results else {return}
            titles = []
            thumbnails = []
            for result in results {
                guard let title = result["title"] as? String,
                      let temp = result["thumbnail"] as? [String: String],
                      let path = temp["path"],
                      let ext = temp["extension"] else {fatalError()}
                
                let thumbnail = Thumbnail(path: path, ext: ext)
                
                titles.append(title)
                thumbnails.append(thumbnail)
            }
        }
    }
}
