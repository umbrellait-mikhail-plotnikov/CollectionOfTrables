//
//  ViewController.swift
//  CollectionViewRxDataSource
//
//  Created by Mikhail Plotnikov on 07.04.2021.
//
import RxSwift
import RxCocoa
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ViewModel()
        
        viewModel!.addNewSource(newSource: "Source1")
        viewModel!.addNewSource(newSource: "Source2")
        
        tableView.register(UINib(nibName: "HorizontalCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "Cells")
        
        viewModel?.sourcesArray.bind(to: tableView.rx.items) { (table, row, element) in
            guard let cell = table.dequeueReusableCell(withIdentifier: "Cells") as? HorizontalCollectionTableViewCell else {fatalError()}
            //Мой первый вариант
            //cell.collectionView.register(UINib(nibName: "ResourceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
//            self.viewModel?.randomArray.bind(to: cell.collectionView.rx.items(cellIdentifier: "CollectionCell", cellType: ResourceCollectionViewCell.self)) { row, collectionData, cell in
//
//            }.disposed(by: self.disposeBag)
//            return cell
            
//            Мой второй вариант
//            Оба не работают, collectionView не отображается :(
            return cell.configure()
            
        }
        .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }


}

