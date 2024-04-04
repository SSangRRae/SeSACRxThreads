//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/1/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class SearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let plusButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        return view
    }()
    
    let viewModel = SearchViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bind()
    }
    
    func bind() {
        let plusButtonTap = plusButton.rx.tap
        let tableSelected = Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
        let searchBarText = searchBar.rx.text
        let searchButtonClicked = searchBar.rx.searchButtonClicked
        
        let input = SearchViewModel.Input(plusButtonTap: plusButtonTap, tableSelected: tableSelected, searchBarText: searchBarText, searchButtonClicked: searchButtonClicked)
        
        viewModel.transform(input)
        
        viewModel.list.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: SearchTableViewCell.self)) { row, element, cell in
            cell.dataTextLabel.text = element
            cell.button.rx.tap.bind(with: self) { owner, _ in
                let alert = UIAlertController(title: "test", message: "asdf", preferredStyle: .alert)
                let button = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(button)
                
                owner.present(alert, animated: true)
            }
            .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
    }
    
    func configureView() {
        let right = UIBarButtonItem(customView: plusButton)
        navigationItem.rightBarButtonItem = right
        view.backgroundColor = .white
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        searchBar.autocapitalizationType = .none
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
