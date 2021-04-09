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
    
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let refreshController = UIRefreshControl()
    private let disposeBag = DisposeBag()
    private let viewModel: MainViewModel!
    
    private func refresh() {
        var count = 0
        viewModel?.reloadData() {
            count += 1
            if count == 3 {
                self.refreshController.endRefreshing()
            }
        }
    }
    
    private func setupUI() {
        refreshController.attributedTitle = NSAttributedString(string: "WIPE DATA... AHAHHAHAH")
        
        refreshController.rx.controlEvent(.valueChanged)
            .subscribe { [weak self] _ in self?.refresh() }
            .disposed(by: disposeBag)
        
        tableView.refreshControl = refreshController
        
        spinner.color = .darkGray
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: "GridViewCell", bundle: nil), forCellReuseIdentifier: "GridCell")
        tableView.register(UINib(nibName: "CreatorViewCell", bundle: nil), forCellReuseIdentifier: "CreatorViewCell")
    }
    
    private func updateVisibleFooter(status: Bool) {
        self.tableView.tableFooterView?.isHidden = !status
        
        if self.tableView.contentOffset.y < 100 {
            self.tableView.tableFooterView?.isHidden = false
        }
    }
    
    private func bindTableView(tableView: UITableView) {
        viewModel?.items
            .drive(tableView.rx.items(dataSource: viewModel!.dataSource))
            .disposed(by: disposeBag)
        tableView.rx.contentOffset
            .map { $0.y >= tableView.contentSize.height - tableView.frame.height - 200 }
            .map { $0 && tableView.contentOffset.y > 100 }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                if $0 {
                    self?.viewModel?.getCreators(limit: 10)
                }
                self?.updateVisibleFooter(status: $0)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupUI()
        bindTableView(tableView: tableView)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        viewModel = MainViewModel(api: MarvelAPIProvider.shared)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        viewModel = MainViewModel(api: MarvelAPIProvider.shared)
        super.init(coder: coder)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 150
        } else if indexPath.section == 1 {
            return 50
        } else {
            return 250
        }
    }
}
