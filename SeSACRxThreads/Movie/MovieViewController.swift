//
//  MovieViewController.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MovieViewController: UIViewController {
    
    let searchBar = UISearchBar()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    let tableView = UITableView()
    let viewModel = MovieViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bind()
    }
    
    func bind() {
        let searchText = searchBar.rx.text
        let searchButtonClicked = searchBar.rx.searchButtonClicked
        let tableViewSelected = Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(BoxOfficeList.self))
        
        let input = MovieViewModel.Input(
            searchText: searchText,
            searchButtonClicked: searchButtonClicked,
            tableViewSelected: tableViewSelected)
        let output = viewModel.transform(input)
        
        output.tableViewList.drive(tableView.rx.items(cellIdentifier: "cell", cellType: MovieTableViewCell.self)) {
            row, element, cell in
            cell.configureCell(element)
        }
        .disposed(by: disposeBag)
        
        output.collectionViewList.drive(collectionView.rx.items(cellIdentifier: "collectionCell", cellType: MovieCollectionViewCell.self)) {
            row, element, cell in
            
            cell.nameLabel.text = element
        }
        .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")
        
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
    }
    
    func createLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
