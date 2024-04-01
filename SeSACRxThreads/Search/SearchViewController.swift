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
    
    var data = ["a", "b", "c", "ac", "ab", "abc"]
    lazy var list = BehaviorSubject(value: data)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bind()
    }
    
    func bind() {
        list.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: SearchTableViewCell.self)) { row, element, cell in
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
        
        plusButton.rx.tap.bind(with: self) { owner, _ in
            let temp = ["ba", "bcd", "bbbb", "cd", "ccc"]
            
            owner.data.append(temp.randomElement()!)
            owner.list.onNext(owner.data)
        }
        .disposed(by: disposeBag)
        
        // combineLatest
        /*
         두 개의 시퀀스가 모두 첫 이벤트를 방출하고
         이후에는 하나의 이벤트만 방출 하더라도 다른 하나의 시퀀스의 이전 이벤트와 함께 방출
         그래서 tableView를 select 하면 2개의 이벤트가 동시에 방출되기 때문에
         data의 값이 2번 지워짐...
         */
        //        Observable.combineLatest(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
        //            .bind(with: self) { owner, value in
        //                print(owner.data)
        //                owner.data.remove(at: value.0.row)
        //                owner.list.onNext(owner.data)
        //            }
        //            .disposed(by: disposeBag)
        
        // zip
        /*
         두 개의 시퀀스가 새로운 이벤트 방출해야함..!
         */
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind(with: self) { owner, value in
                owner.data.remove(at: value.0.row)
                owner.list.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        
        // debounce: async after와 비슷한 기능을 하는 operator
        // distinctUntilChanged: 이전 값과 동일하면 무시하는 operator
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                let result = text.isEmpty ? owner.data : owner.data.filter { $0.contains(text) }
                owner.list.onNext(result)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                let result = text.isEmpty ? owner.data : owner.data.filter { $0.contains(text) }
                owner.list.onNext(result)
            }
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        let right = UIBarButtonItem(customView: plusButton)
        navigationItem.rightBarButtonItem = right
        view.backgroundColor = .white
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        
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
