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
            if (viewModel?.data.value as? [Character]) != nil {
                collectionView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageViewCell")
                
                viewModel!.data.bind(to: collectionView.rx.items(cellIdentifier: "ImageViewCell", cellType: ImageViewCell.self)) { index, character, cell in
                    
                    cell.character = character as? Character
                
                }.disposed(by: disposedBag)
            }
            else if (viewModel?.data.value as? [Comics]) != nil {
                collectionView.register(UINib(nibName: "ComicsViewCell", bundle: nil), forCellWithReuseIdentifier: "ComicsViewCell")
                
                viewModel!.data.bind(to: collectionView.rx.items(cellIdentifier: "ComicsViewCell", cellType: ComicsViewCell.self)) { index, comics, cell in
                    
                    cell.comics = comics as? Comics
                    
                }.disposed(by: disposedBag)
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.rx.contentOffset
            .map { $0.x > self.collectionView.contentSize.width - self.collectionView.frame.width * 4 }
            .map { $0 && self.collectionView.contentSize.width != 0 }
            .distinctUntilChanged()
            .subscribe(onNext: {
                if $0 { self.viewModel?.getNewItems(limit: 50) }
            })
            .disposed(by: disposedBag)
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
