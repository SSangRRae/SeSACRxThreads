//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa

struct User {
    let email = "abc@abc.com"
    let password = "qwerasdfzxcv"
}

class SignInViewModel {
    
    private let user = User()
    
    let validationText = PublishSubject<String>()
    
    let inputButtonTap = PublishSubject<(String?, String?)>()
    
    let disposeBag = DisposeBag()
    
    init() {
        inputButtonTap.subscribe(with: self) { owner, value in
            if value.0 == owner.user.email && value.1 == owner.user.password {
                owner.validationText.onNext("환영합니다. \(owner.user.email)님")
            } else {
                owner.validationText.onNext("일치하는 사용자가 없습니다.")
            }
        }
        .disposed(by: disposeBag)
    }
}
