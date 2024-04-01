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
    var complete: Bool = false
    let name: String
    var favorite: Bool = false
    
    init(name: String) {
        self.name = name
    }
}

final class ShoppingViewController: UIViewController {
    
    private let shoppingView = ShoppingView()
    
    var data: [ShoppingItemList] = []
    lazy var list = PublishSubject<[ShoppingItemList]>()
    
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
        list.bind(to: shoppingView.tableView.rx.items(cellIdentifier: "cell", cellType: ShoppingTableViewCell.self)) { row, element, cell in
            
            cell.configureCell(element)
            
            cell.completeButton.rx.tap.bind(with: self) { owner, _ in
                owner.data[row].complete.toggle()
                owner.list.onNext(owner.data)
            }.disposed(by: cell.disposeBag)
            cell.favoriteButton.rx.tap.bind(with: self) { owner, _ in
                owner.data[row].favorite.toggle()
                owner.list.onNext(owner.data)
            }.disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        shoppingView.addButton.rx.tap.bind(with: self) { owner, _ in
            guard let text = owner.shoppingView.textField.text else { return }
            
            owner.data.append(ShoppingItemList(name: text))
            owner.list.onNext(owner.data)
        }
        .disposed(by: disposeBag)
        
        Observable.zip(shoppingView.tableView.rx.itemSelected, shoppingView.tableView.rx.modelSelected(ShoppingItemList.self))
            .bind(with: self) { owner, value in
                owner.data.remove(at: value.0.row)
                owner.list.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        shoppingView.searchBar
            .rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
            let result = text.isEmpty ? owner.data : owner.data.filter { $0.name.contains(text) }
            owner.list.onNext(result)
        }.disposed(by: disposeBag)
        
        shoppingView.searchBar
            .rx
            .searchButtonClicked
            .withLatestFrom(shoppingView.searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                let result = text.isEmpty ? owner.data : owner.data.filter { $0.name.contains(text) }
                owner.list.onNext(result)
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
