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
    let emailDescriptionLable = UILabel()
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let passwordDescriptionLabel = UILabel()
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    let emailValidationText = Observable.just("이메일 형식이 잘못되었습니다. (@, . 미포함)")
    let passwordValidationText = Observable.just("비밀번호는 10글자 이상입니다.")
    let validationColor = Observable.just(UIColor.red)
    
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        bind()
    }
    
    func bind() {
        // 이메일, 비밀번호 유효성 검사 text bind
        emailValidationText.bind(to: emailDescriptionLable.rx.text).disposed(by: disposeBag)
        passwordValidationText.bind(to: passwordDescriptionLabel.rx.text).disposed(by: disposeBag)
        
        // 빨간색
        validationColor.bind(to: emailDescriptionLable.rx.textColor, passwordDescriptionLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        // 이메일에 '@', '.' 이 포함되어 있지 않으면 형식이 잘못되었다고 판단...
        let emailTextCount = emailTextField.rx.text.orEmpty.map { $0.contains("@") && $0.contains(".") }
        emailTextCount.bind(to: emailDescriptionLable.rx.isHidden).disposed(by: disposeBag)
        
        // 비밀번호는 10글자 이상
        let passwordTextCount = passwordTextField.rx.text.orEmpty.map { $0.count >= 10 }
        passwordTextCount.bind(to: passwordDescriptionLabel.rx.isHidden).disposed(by: disposeBag)
        
        // 이메일과 패스워드가 맞아야 로그인 버튼을 누를 수 있게..
        let emailSame = emailTextField.rx.text.orEmpty.map { $0 == self.user.email }
        let passwordSame = passwordTextField.rx.text.orEmpty.map { $0 == self.user.password }
        
        Observable.combineLatest(emailSame, passwordSame) { a, b in
            return a && b
        }
        .bind(to: signInButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        signInButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
        
        emailTextField.autocapitalizationType = .none
        passwordTextField.autocapitalizationType = .none
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(emailDescriptionLable)
        view.addSubview(passwordTextField)
        view.addSubview(passwordDescriptionLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailDescriptionLable.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailDescriptionLable.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordDescriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordDescriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
