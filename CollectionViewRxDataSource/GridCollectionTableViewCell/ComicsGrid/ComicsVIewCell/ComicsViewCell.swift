//
//  ComicsViewCell.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import UIKit

class ComicsViewCell: UICollectionViewCell {

    var comics: String! {
        didSet {
            label.text = comics
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
