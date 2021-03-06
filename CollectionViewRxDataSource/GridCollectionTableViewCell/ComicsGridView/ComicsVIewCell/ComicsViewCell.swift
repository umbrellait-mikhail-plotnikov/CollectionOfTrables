//
//  ComicsViewCell.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import UIKit

class ComicsViewCell: UICollectionViewCell {

    
    @IBOutlet weak var colorView: UIView!
    
    var comics: Comics! {
        didSet {
            label.text = comics.title
            colorView.layer.cornerRadius = 10
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

extension String {
    func width(height: CGFloat, font: UIFont = .systemFont(ofSize: 17)) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}
