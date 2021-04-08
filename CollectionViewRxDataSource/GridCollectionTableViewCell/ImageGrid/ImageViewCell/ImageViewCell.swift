//
//  ResourceCollectionViewCell.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//

import UIKit
import Kingfisher

class ImageViewCell: UICollectionViewCell {

    var character: Character! {
        didSet {
            image.kf.setImage(with: URL(string: character.thumbnail.toString()))
        }
    }
    
    @IBOutlet weak var image: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

}
