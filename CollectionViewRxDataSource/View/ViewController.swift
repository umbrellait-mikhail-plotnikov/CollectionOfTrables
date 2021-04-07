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
        tableView.isScrollEnabled = true
        
        tableView.register(UINib(nibName: "HorizontalCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell1")
        
        viewModel = ViewModel()
        
        viewModel?.items
            .bind(to: tableView.rx.items(dataSource: viewModel!.dataSource))
            .disposed(by: disposeBag)
        
    }
}

