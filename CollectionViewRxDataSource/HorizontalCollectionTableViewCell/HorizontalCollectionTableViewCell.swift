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

    let disposedBag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: GridViewModel?  {
        didSet {
            collectionView.register(UINib(nibName: "ResourceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ResourceCollectionViewCell")
            data?.titles.bind(to: collectionView.rx.items(cellIdentifier: "ResourceCollectionViewCell", cellType: ResourceCollectionViewCell.self)) { index, title, cell in
                cell.title = title
            
            }.disposed(by: disposedBag)
        }
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
