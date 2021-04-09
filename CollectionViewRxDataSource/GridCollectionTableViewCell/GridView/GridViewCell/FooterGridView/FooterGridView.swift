//
//  FooterGridView.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 09.04.2021.
//

import UIKit

class FooterGridView: UICollectionReusableView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
        // Initialization code
    }
    
}
