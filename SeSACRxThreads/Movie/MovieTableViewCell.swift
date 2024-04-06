//
//  MovieTableViewCell.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/6/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    let rankLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    let nameLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .boldSystemFont(ofSize: 20)
        return view
    }()
    
    let openDateLabel = {
        let view = UILabel()
        view.textColor = .white
        view.backgroundColor = .systemBlue
        view.font = .systemFont(ofSize: 12)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ item: BoxOfficeList) {
        rankLabel.text = item.rank
        nameLabel.text = item.movieNm
        openDateLabel.text = item.openDt
    }
    
    func configureView() {
        contentView.addSubview(rankLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(openDateLabel)
        
        rankLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(rankLabel.snp.trailing).offset(16)
            make.width.equalTo(200)
        }
        
        openDateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
