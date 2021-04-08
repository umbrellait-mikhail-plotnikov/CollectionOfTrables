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
    var viewModel: MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = true
        
        tableView.register(UINib(nibName: "GridViewCell", bundle: nil), forCellReuseIdentifier: "GridCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        viewModel = MainViewModel(api: MarvelAPIProvider.shared)
        
        viewModel?.items
            .bind(to: tableView.rx.items(dataSource: viewModel!.dataSource))
            .disposed(by: disposeBag)
        
    }
}


