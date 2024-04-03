//
//  PasswordViewModel.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class PasswordViewModel {
    
    let validText = PublishSubject<String>()
    
    let inputPassword = PublishSubject<Bool>()
    
    let disposeBag = DisposeBag()
    
    init() {
        inputPassword.bind(with: self) { owner, state in
            let text: String = state ? "사용 가능한 비밀번호입니다" : "8자 이상 입력해주세요"
            owner.validText.onNext(text)
        }
        .disposed(by: disposeBag)
    }
}
