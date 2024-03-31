//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    
    private let emails = ["123@123.com", "qwer@qwer.com", "asdf@asdf.com"]

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let descriptionLabel = UILabel()
    let nextButton = PointButton(title: "다음")
    
    let validation = BehaviorSubject(value: false)
    let validationText = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        bind()
    }
    
    func bind() {
        validation.bind(to: nextButton.rx.isEnabled).disposed(by: disposeBag)
        validationText.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        Observable.just(UIColor.lightGray).bind(to: nextButton.rx.backgroundColor).disposed(by: disposeBag)
        
        validationButton.rx.tap.bind(with: self) { owner, _ in
            if owner.emails.contains(owner.emailTextField.text!) {
                owner.validation.onNext(false)
                owner.validationText.onNext("사용할 수 없는 이메일입니다.")
                Observable.just(UIColor.red).bind(to: owner.descriptionLabel.rx.textColor).disposed(by: owner.disposeBag)
                Observable.just(UIColor.lightGray).bind(to: owner.nextButton.rx.backgroundColor).disposed(by: owner.disposeBag)
            } else {
                owner.validation.onNext(true)
                owner.validationText.onNext("사용 가능한 이메일입니다!")
                Observable.just(UIColor.blue).bind(to: owner.descriptionLabel.rx.textColor).disposed(by: owner.disposeBag)
                Observable.just(UIColor.black).bind(to: owner.nextButton.rx.backgroundColor).disposed(by: owner.disposeBag)
            }
        }
        .disposed(by: disposeBag)
        
        nextButton.rx.tap.bind(with: self) { owner, _ in
            owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
        }
        .disposed(by: disposeBag)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(descriptionLabel)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
