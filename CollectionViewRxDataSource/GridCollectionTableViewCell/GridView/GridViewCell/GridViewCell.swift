//
//  VerticalCollectionTableViewCell.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//
import RxSwift
import RxCocoa
import RxDataSources
import UIKit

class GridViewCell: UITableViewCell {

    private enum GridType {
        case Character
        case Comics
    }
    
    private var isCharacterLoading = true
    private var isComicsLoading = true
    
    private let disposedBag = DisposeBag()
    @IBOutlet weak var collectionView: UICollectionView!
    
    private func setupCollectionView(viewModel: GridViewModelProtocol, type: GridType) {
        if type == .Character {
            guard let viewModel = viewModel as? ImageGridViewModel else {fatalError()}
            
            collectionView.register(UINib(nibName: "ImageViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageViewCell")
            
            viewModel.dataSource.configureSupplementaryView = { [weak self] (dataSource, collectionView, kind, indexPath) in
                guard let self = self else { return UICollectionReusableView() }
                return self.setupFooterGridView(indexPath: indexPath, type: .Character)
            }
            viewModel.characters.drive(collectionView.rx.items(dataSource: viewModel.dataSource))
                .disposed(by: disposedBag)
            
        } else if type == .Comics {
            guard let viewModel = viewModel as? ComicsGridViewModel else { fatalError() }
            
            collectionView.register(UINib(nibName: "ComicsViewCell", bundle: nil), forCellWithReuseIdentifier: "ComicsViewCell")
    
            viewModel.dataSource.configureSupplementaryView = { [weak self] (dataSource, collectionView, kind, indexPath) in
                guard let self = self else { return UICollectionReusableView() }
                return self.setupFooterGridView(indexPath: indexPath, type: .Comics)
            }
            viewModel.comics.drive(collectionView.rx.items(dataSource: viewModel.dataSource))
                .disposed(by: disposedBag)
            
            collectionView.rx.setDelegate(self).disposed(by: disposedBag)
        } else {fatalError()}
    }
    
    private func setupFooterGridView(indexPath: IndexPath, type: GridType) -> FooterGridView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath) as! FooterGridView
        
        if type == .Character {
            self.isCharacterLoading ? footer.activityIndicator.startAnimating() : footer.activityIndicator.stopAnimating()
        } else if type == .Comics {
            self.isComicsLoading ? footer.activityIndicator.startAnimating() : footer.activityIndicator.stopAnimating()
        }
        
        return footer
    }
    
    private func requestNewData(viewModel: GridViewModelProtocol?) {
        if (viewModel as? ComicsGridViewModel) != nil {
            isComicsLoading = true
            self.viewModel?.getNewItems(limit: 10) {
                self.isComicsLoading = false
            }
        } else if (self.viewModel as? ImageGridViewModel) != nil {
            self.isCharacterLoading = true
            self.viewModel?.getNewItems(limit: 10) {
                self.isCharacterLoading = false
            }
        }
    }
    
    private func bindCollectionView(collectionView: UICollectionView) {
        collectionView.rx.contentOffset
            .map { $0.x > collectionView.contentSize.width - collectionView.frame.width - 100 }
            .map { $0 && collectionView.contentSize.width != 0 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if $0 {
                    self.requestNewData(viewModel: self.viewModel)
                }
            })
            .disposed(by: disposedBag)
    }
    
    var viewModel: GridViewModelProtocol?  {
        didSet {
            if (viewModel?.data.value as? [Character]) != nil {
                setupCollectionView(viewModel: viewModel!, type: .Character)
            }
            else if (viewModel?.data.value as? [Comics]) != nil {
                setupCollectionView(viewModel: viewModel!, type: .Comics)
            } else { fatalError() }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "FooterGridView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        
        bindCollectionView(collectionView: collectionView)
        
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

extension GridViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comics = viewModel?.data.value[indexPath.row] as! Comics
        let width = comics.title.width(height: 35) + 25
        return CGSize(width: width, height: 35)
    }    
}
