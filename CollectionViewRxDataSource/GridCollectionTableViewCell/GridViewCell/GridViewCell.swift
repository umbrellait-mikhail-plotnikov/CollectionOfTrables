//
//  VerticalCollectionTableViewCell.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//
import RxSwift
import RxCocoa
import UIKit

class GridViewCell: UITableViewCell {

    let disposedBag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: GridViewModelProtocol?  {
        didSet {
            if (viewModel?.data.value as? [URL]) != nil {
                collectionView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageViewCell")
                
                viewModel!.data.bind(to: collectionView.rx.items(cellIdentifier: "ImageViewCell", cellType: ImageViewCell.self)) { index, imageURL, cell in
                    
                    cell.imageURL = imageURL as? URL
                
                }.disposed(by: disposedBag)
            }
            else if (viewModel?.data.value as? [String]) != nil {
                collectionView.register(UINib(nibName: "ComicsViewCell", bundle: nil), forCellWithReuseIdentifier: "ComicsViewCell")
                
                viewModel!.data.bind(to: collectionView.rx.items(cellIdentifier: "ComicsViewCell", cellType: ComicsViewCell.self)) { index, comicsTitle, cell in
                    
                    cell.comics = comicsTitle as? String
                    
                }.disposed(by: disposedBag)
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
