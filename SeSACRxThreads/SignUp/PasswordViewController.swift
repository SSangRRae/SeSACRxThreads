//
//  PasswordViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PasswordViewController: UIViewController {
    
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let validText = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        validText.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        
        let validation = passwordTextField
            .rx
            .text
            .orEmpty
            .map { $0.count >= 8 }
        
        validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .black : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        validation.bind(with: self) { owner, state in
            let text: String = state ? "사용 가능한 비밀번호입니다" : "8자 이상 입력해주세요"
            owner.validText.onNext(text)
            
            let color: UIColor = state ? .blue : .red
            owner.descriptionLabel.textColor = color
        }
        .disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(PhoneViewController(), animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(passwordTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(passwordTextField.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
}
