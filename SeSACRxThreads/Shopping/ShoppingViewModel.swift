//
//  ShoppingViewModel.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/4/24.
//

import Foundation
import RxSwift
import RxCocoa

struct ShoppingItemList {
    var id: Date = Date()
    var complete: Bool = false
    let name: String
    var favorite: Bool = false
    
    init(name: String) {
        self.name = name
    }
}

class ShoppingViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    var originData: [ShoppingItemList] = []
    let list = PublishRelay<[ShoppingItemList]>()
    
    struct Input {
        let addText: ControlProperty<String?>
        let addButtonTap: ControlEvent<Void>
        let tableSelected: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<ShoppingItemList>.Element)>
        let searchBarText: ControlProperty<String?>
        let searchButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    @discardableResult
    func transform(_ input: Input) -> Output {
        input.addButtonTap
            .withLatestFrom(input.addText.orEmpty)
            .bind(with: self) { owner, text in
                owner.originData.append(ShoppingItemList(name: text))
                owner.list.accept(owner.originData)
            }
            .disposed(by: disposeBag)
        
        input.tableSelected.bind(with: self) { owner, value in
            owner.originData.removeAll { list in list.id == value.1.id }
            owner.list.accept(owner.originData)
        }
        .disposed(by: disposeBag)
        
        input.searchBarText.orEmpty
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                let temp = text.isEmpty ? owner.originData : owner.originData.filter { $0.name.contains(text) }
                owner.list.accept(temp)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonClicked.withLatestFrom(input.searchBarText.orEmpty)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                let temp = text.isEmpty ? owner.originData : owner.originData.filter { $0.name.contains(text) }
                owner.list.accept(temp)
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
