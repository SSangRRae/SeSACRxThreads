//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/1/24.
//

import UIKit
import RxSwift
import RxCocoa

final class ShoppingViewController: UIViewController {
    
    private let shoppingView = ShoppingView()
    let viewModel = ShoppingViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = shoppingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
        bind()
    }
}

extension ShoppingViewController {
    func bind() {
        let addText = shoppingView.textField.rx.text
        let addButtonTap = shoppingView.addButton.rx.tap
        let tableSelected = Observable.zip(shoppingView.tableView.rx.itemSelected, shoppingView.tableView.rx.modelSelected(ShoppingItemList.self))
        let searchBarText = shoppingView.searchBar.rx.text
        let searchButtonClicked = shoppingView.searchBar.rx.searchButtonClicked
        
        let input = ShoppingViewModel.Input(addText: addText, addButtonTap: addButtonTap, tableSelected: tableSelected, searchBarText: searchBarText, searchButtonClicked: searchButtonClicked)
        
        viewModel.transform(input)
        
        viewModel.list.bind(to: shoppingView.tableView.rx.items(cellIdentifier: "cell", cellType: ShoppingTableViewCell.self)) { row, element, cell in
            
            cell.configureCell(element)
            
            cell.completeButton.rx.tap.bind(with: self) { owner, _ in
                owner.viewModel.originData[row].complete.toggle()
                owner.viewModel.list.accept(owner.viewModel.originData)
            }
            .disposed(by: cell.disposeBag)
            
            cell.favoriteButton.rx.tap.bind(with: self) { owner, _ in
                owner.viewModel.originData[row].favorite.toggle()
                owner.viewModel.list.accept(owner.viewModel.originData)
            }
            .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
    }
}

// MARK: design view
extension ShoppingViewController {
    func configureNavigationBar() {
        navigationItem.titleView = shoppingView.searchBar
    }
    
    func configureView() {
        shoppingView.tableView.register(ShoppingTableViewCell.self, forCellReuseIdentifier: "cell")
    }
}
