//
//  CreatorViewCell.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import UIKit
import Kingfisher

class CreatorViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageCreator: UIImageView!
    
    var creator: Creator! {
        didSet {
            nameLabel.text = creator.name
            imageCreator.kf.setImage(with: URL(string: creator.thumbnail.toString()))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
