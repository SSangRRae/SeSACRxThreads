//
//  SearchTableViewCell.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/1/24.
//

import UIKit
import RxSwift

class SearchTableViewCell: UITableViewCell {
    
    let dataTextLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        view.textColor = .black
        return view
    }()
    
    let button = {
        let view = UIButton()
        view.setTitle("더 보기", for: .normal)
        view.backgroundColor = .lightGray
        view.titleLabel?.textColor = .black
        return view
    }()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dataTextLabel)
        contentView.addSubview(button)
        
        dataTextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.leading.equalToSuperview().offset(30)
            make.height.equalTo(30)
        }
        
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}
