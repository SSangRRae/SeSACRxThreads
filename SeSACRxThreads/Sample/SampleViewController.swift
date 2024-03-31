//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 3/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SampleViewController: UIViewController {
    
    let textField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "입력"
        return view
    }()
    
    let addButton = {
        let view = UIButton()
        view.setTitle("추가", for: .normal)
        view.backgroundColor = .lightGray
        return view
    }()
    
    let tableView = UITableView()
    
    var names = ["1", "2", "3"]
    
    var list = BehaviorRelay<[String]>(value: [])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        bind()
    }
    
    func bind() {
        
        // list -> tableview
        list.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
            cell.textLabel?.text = "\(element) @ row \(row)"
        }
        .disposed(by: disposeBag)
        
        // 입력한 텍스트 추가
        addButton.rx.tap.bind(with: self) { owner, _ in
            guard let text = owner.textField.text else { return }
            var value = owner.list.value
            value.append(text)
            
            owner.list.accept(value)
        }
        .disposed(by: disposeBag)
        
        // 데이터 삭제
        tableView.rx.itemSelected.bind(with: self) { owner, indexPath in
            var value = owner.list.value
            value.remove(at: indexPath.row)
            
            owner.list.accept(value)
        }
        .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.backgroundColor = .white
        
        view.addSubview(textField)
        view.addSubview(addButton)
        view.addSubview(tableView)
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(textField)
            make.leading.equalTo(textField.snp.trailing).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}
