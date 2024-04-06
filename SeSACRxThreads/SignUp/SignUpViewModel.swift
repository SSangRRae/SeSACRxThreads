//
//  SignUpViewModel.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let email: ControlProperty<String?>
        let validButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let validation: Driver<Bool>
        let validationText: Driver<String>
    }
    
    func transform(_ input: Input) -> Output {
        let emails = ["123@123.com", "qwer@qwer.com", "asdf@asdf.com"]
        let validationText = PublishRelay<String>()
        
        let form = input.email.orEmpty.map { $0.count > 0 && $0.contains("@") && $0.contains(".") }
        
        let duplicated = input.validButtonTap
            .withLatestFrom(input.email.orEmpty)
            .map { !emails.contains($0) }
        
        form.bind(with: self) { owner, state in
            validationText.accept(state ? " " : "'@', '.'을 포함해주세요.")
        }
        .disposed(by: disposeBag)
        
        duplicated.bind(with: self) { owner, state in
            validationText.accept(state ? "사용할 수 있는 이메일입니다." : "중복된 이메일입니다.")
        }
        .disposed(by: disposeBag)
        
        let valid = Observable.combineLatest(form, duplicated) { a, b in
            return a && b
        }.asDriver(onErrorJustReturn: false)
        
        return Output(validation: valid, validationText: validationText.asDriver(onErrorJustReturn: ""))
    }
}
