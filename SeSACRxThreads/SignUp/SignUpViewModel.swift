//
//  SignUpViewModel.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    
    private let emails = ["123@123.com", "qwer@qwer.com", "asdf@asdf.com"]
    
    let validation = BehaviorSubject(value: false)
    let validationText = PublishSubject<String>()
    
    let inputButtonTap = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    init() {
        inputButtonTap.bind(with: self) { owner, value in
            if owner.emails.contains(value) {
                owner.validation.onNext(false)
                owner.validationText.onNext("사용할 수 없는 이메일입니다.")
            } else {
                owner.validation.onNext(true)
                owner.validationText.onNext("사용 가능한 이메일입니다!")
            }
        }
        .disposed(by: disposeBag)
    }
}
