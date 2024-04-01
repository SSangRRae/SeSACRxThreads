//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/1/24.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell {
    
    let completeButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        view.tintColor = .black
        return view
    }()
    
    let itemLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .black
        return view
    }()
    
    let favoriteButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "star"), for: .normal)
        view.tintColor = .black
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHirerachy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHirerachy() {
        contentView.addSubview(completeButton)
        contentView.addSubview(itemLabel)
        contentView.addSubview(favoriteButton)
    }
    
    func configureConstraints() {
        completeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
        
        itemLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.leading.equalTo(completeButton.snp.trailing).offset(16)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
    }
}
