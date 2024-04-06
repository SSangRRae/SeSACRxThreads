//
//  MovieCollectionViewCell.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/6/24.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    let nameLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textAlignment = .center
        view.backgroundColor = .systemBlue
        view.textColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
