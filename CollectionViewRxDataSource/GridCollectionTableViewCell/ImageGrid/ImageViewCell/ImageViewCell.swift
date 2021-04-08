//
//  ResourceCollectionViewCell.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//

import UIKit

class ImageViewCell: UICollectionViewCell {

    var image: String! {
        didSet {
            label.text = image
            
        }
    }
    @IBOutlet weak var label: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

}
