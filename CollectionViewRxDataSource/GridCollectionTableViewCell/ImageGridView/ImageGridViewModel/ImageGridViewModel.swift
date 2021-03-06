//
//  GridViewModel.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 08.04.2021.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

struct ImageSection {
    var header: String
    var items: [Item]
}

extension ImageSection: SectionModelType {
    typealias Item = Character
    
    init(original: ImageSection, items: [Character]) {
        self = original
        self.items = items
    }
}

struct ImageGridViewModel: GridViewModelProtocol {
    
    private let disposedBag = DisposeBag()
    let _characters = BehaviorRelay<[ImageSection]>(value: [])
    var characters: Driver<[ImageSection]> {
        return _characters.asDriver()
    }
    
    let data = BehaviorRelay<[Any]>(value: [])
    let dataSource = RxCollectionViewSectionedReloadDataSource<ImageSection>(configureCell: { dataSource, collectionView, indexPath, element in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
        
        cell.character = element
        
        return cell
        
    })
    
    func getNewItems(limit: Int, closure: @escaping () -> ()) {
        MarvelAPIProvider.shared.getCharacters(limit: limit, offset: data.value.count)
            .map { $0.characters }
            .subscribe(onNext: {
                self.data.accept(self.data.value + $0)
                self._characters.accept([ImageSection(header: "Image Section", items: self.data.value as! [Character])])
                closure()
            }).disposed(by: disposedBag)
    }
    
    init(characters: [Character]) {
        self.data.accept(characters)
        self._characters.accept([ImageSection(header: "Image Section", items: characters)])
    }
}
