//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    let list = PublishRelay<[String]>()
    var data = ["a", "b", "c", "ac", "ab", "abc"]
    
    struct Input {
        let plusButtonTap: ControlEvent<Void>
        let tableSelected: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<String>.Element)>
        let searchBarText: ControlProperty<String?>
        let searchButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
       
    }
    
    @discardableResult
    func transform(_ input: Input) -> Output {
        input.plusButtonTap.bind(with: self) { owner, _ in
            let temp = ["ba", "bcd", "bbbb", "cd", "ccc"]
            
            owner.data.append(temp.randomElement()!)
            owner.list.accept(owner.data)
        }
        .disposed(by: disposeBag)
        
        input.tableSelected.bind(with: self) { owner, value in
            owner.data.remove(at: value.0.row)
            owner.list.accept(owner.data)
        }
        .disposed(by: disposeBag)
        
        input.searchBarText.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                let result = text.isEmpty ? owner.data : owner.data.filter { $0.contains(text) }
                owner.list.accept(result)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonClicked
            .withLatestFrom(input.searchBarText.orEmpty)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                let result = text.isEmpty ? owner.data : owner.data.filter { $0.contains(text) }
                owner.list.accept(result)
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
