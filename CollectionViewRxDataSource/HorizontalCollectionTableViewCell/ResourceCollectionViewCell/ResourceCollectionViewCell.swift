//
//  ResourceCollectionViewCell.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//

import UIKit

class ResourceCollectionViewCell: UICollectionViewCell {

    var title: String! {
        didSet {
            label.text = title
            label.sizeToFit()
        }
    }
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("CollectionCell awake!")
        
        // Initialization code
    }

}
