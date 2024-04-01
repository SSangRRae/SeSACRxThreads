//
//  ShoppingViewController.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/1/24.
//

import UIKit
import RxSwift
import RxCocoa

struct ShoppingItemList {
    let complete: Bool
    let name: String
    let favorite: Bool
}

final class ShoppingViewController: UIViewController {
    
    private let shoppingView = ShoppingView()
    
    var data: [ShoppingItemList] = [ShoppingItemList(complete: false, name: "asdfasdf", favorite: false)]
    
    lazy var list = BehaviorSubject(value: data)
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = shoppingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureView()
        
        list.bind(to: shoppingView.tableView.rx.items(cellIdentifier: "cell", cellType: ShoppingTableViewCell.self)) { row, element, cell in
            cell.itemLabel.text = element.name
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
