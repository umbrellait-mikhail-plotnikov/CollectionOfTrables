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
    
    let spinner = UIActivityIndicatorView(style: .medium)
    let refreshController = UIRefreshControl()
    
    let disposeBag = DisposeBag()
    var viewModel: MainViewModel?
    
    @objc func refresh(sender: AnyObject) {
        viewModel?.reloadData() {
            self.refreshController.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshController.attributedTitle = NSAttributedString(string: "WIPE DATA... AHAHHAHAH")
        self.refreshController.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        spinner.color = .darkGray
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
        
        
        tableView.refreshControl = refreshController
        
        tableView.register(UINib(nibName: "GridViewCell", bundle: nil), forCellReuseIdentifier: "GridCell")
        tableView.register(UINib(nibName: "CreatorViewCell", bundle: nil), forCellReuseIdentifier: "CreatorViewCell")
        
        viewModel = MainViewModel(api: MarvelAPIProvider.shared)
        
        viewModel?.items
            .bind(to: tableView.rx.items(dataSource: viewModel!.dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .map { $0.y >= self.tableView.contentSize.height - self.tableView.frame.height - 200 }
            .map { $0 && self.tableView.contentOffset.y > 100 }
            .distinctUntilChanged()
            .subscribe(onNext: {
                if $0 {
                    self.viewModel?.getCreators(limit: 10)
                }
                self.tableView.tableFooterView?.isHidden = !$0
                
                if self.tableView.contentOffset.y < 100 {
                    self.tableView.tableFooterView?.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        }
        if indexPath.section == 1 {
            return 50
        }
        else {
            return 250
        }
    }
}
