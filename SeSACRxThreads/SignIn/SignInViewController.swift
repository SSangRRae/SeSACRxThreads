//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct User {
    let email = "abc@abc.com"
    let password = "qwerasdfzxcv"
}

class SignInViewController: UIViewController {
    
    private let user = User()

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let descriptionLabel = UILabel()
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    let validationText = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configure()
        bind()
    }
    
    func bind() {
        validationText.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        
        signInButton.rx.tap.bind(with: self) { owner, _ in
            if owner.emailTextField.text == owner.user.email && owner.passwordTextField.text == owner.user.password {
                Observable.just(UIColor.blue).bind(to: owner.descriptionLabel.rx.textColor).disposed(by: owner.disposeBag)
                owner.validationText.onNext("환영합니다. \(owner.user.email)님")
            } else {
                Observable.just(UIColor.red).bind(to: owner.descriptionLabel.rx.textColor).disposed(by: owner.disposeBag)
                owner.validationText.onNext("일치하는 사용자가 없습니다.")
            }
        }
        .disposed(by: disposeBag)
        
        signUpButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
    
    func configure() {
        view.backgroundColor = Color.white
        
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
        
        emailTextField.autocapitalizationType = .none
        passwordTextField.autocapitalizationType = .none
        
        descriptionLabel.textAlignment = .center
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
