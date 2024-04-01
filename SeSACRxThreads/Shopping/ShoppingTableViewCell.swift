//
//  ShoppingTableViewCell.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/1/24.
//

import UIKit
import RxSwift

class ShoppingTableViewCell: UITableViewCell {
    
    let completeButton = {
        let view = UIButton()
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
        view.tintColor = .black
        return view
    }()
    
    var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHirerachy()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configureHirerachy() {
        contentView.addSubview(completeButton)
        contentView.addSubview(itemLabel)
        contentView.addSubview(favoriteButton)
    }
    
    func configureConstraints() {
        completeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
        
        itemLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
            make.leading.equalTo(completeButton.snp.trailing).offset(16)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
    }
    
    func configureCell(_ item: ShoppingItemList) {
        let complete: UIImage? = item.complete ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "checkmark.square")
        let favorite: UIImage? = item.favorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        completeButton.setImage(complete, for: .normal)
        itemLabel.text = item.name
        favoriteButton.setImage(favorite, for: .normal)
    }
}
