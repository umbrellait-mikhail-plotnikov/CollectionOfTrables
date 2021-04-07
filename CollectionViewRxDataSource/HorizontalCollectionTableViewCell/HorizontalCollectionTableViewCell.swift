//
//  VerticalCollectionTableViewCell.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//
import RxSwift
import RxCocoa
import UIKit

class HorizontalCollectionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func configure() -> UITableViewCell {
        self.backgroundColor = .brown
        self.collectionView.backgroundColor = .blue
        return self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("bam")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
