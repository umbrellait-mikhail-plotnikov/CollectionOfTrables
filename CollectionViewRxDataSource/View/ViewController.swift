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
        tableView.register(UINib(nibName: "CreatorViewCell", bundle: nil), forCellReuseIdentifier: "CreatorViewCell")
        
        viewModel = MainViewModel(api: MarvelAPIProvider.shared)
        
        viewModel?.items
            .bind(to: tableView.rx.items(dataSource: viewModel!.dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .map { $0.y >= self.tableView.contentSize.height - self.tableView.frame.height - 200 }
            .map { $0 && self.tableView.contentOffset.y != 0 }
            .distinctUntilChanged()
            .subscribe(onNext: {
                if $0 { self.viewModel?.getCreators(limit: 10) }
            })
            .disposed(by: disposeBag)
        
    }
}


