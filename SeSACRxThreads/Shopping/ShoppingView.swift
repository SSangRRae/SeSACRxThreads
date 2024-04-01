//
//  ShoppingView.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/1/24.
//

import UIKit
import SnapKit

class ShoppingView: UIView {
    
    let searchBar = {
        let view = UISearchBar()
        return view
    }()
    
    let textField = {
        let view = UITextField()
        view.placeholder = "무엇을 구매하실 건가요?"
        view.textColor = .black
        view.borderStyle = .roundedRect
        view.backgroundColor = .systemGray6
        return view
    }()
    
    let addButton = {
        let view = UIButton()
        view.setTitle("추가", for: .normal)
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .systemGray5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        configureHirerachy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHirerachy() {
        addSubview(textField)
        addSubview(addButton)
        addSubview(tableView)
    }
    
    func configureConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.centerY)
            make.trailing.equalTo(textField.snp.trailing).offset(-16)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
