//
//  MovieViewModel.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/5/24.
//

import Foundation
import RxSwift
import RxCocoa

class MovieViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    var list: [String] = []
    
    struct Input {
        // 검색바 text
        let searchText: ControlProperty<String?>
        // searchbuttonclick
        let searchButtonClicked: ControlEvent<Void>
        let tableViewSelected: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<BoxOfficeList>.Element)>
    }
    
    struct Output {
        // tableview list
        let tableViewList: Driver<[BoxOfficeList]>
        let collectionViewList: Driver<[String]>
    }
    
    func transform(_ input: Input) -> Output {
        let list = PublishRelay<[BoxOfficeList]>()
        let collectionViewList = PublishRelay<[String]>()
        
        input.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText.orEmpty)
            .map {
                guard let date = Int($0) else { return 20240101 }
                return date
            }
            .map { String($0) }
            .flatMap { Network.fetchToBoxOffice(date: $0) }
            .subscribe(with: self) { owner, movie in
                let data = movie.boxOfficeResult.dailyBoxOfficeList
                list.accept(data)
            } onError: { _, _ in
                print("Error")
            } onCompleted: { _ in
                print("Complete")
            } onDisposed: { _ in
                print("Disposed")
            }
            .disposed(by: disposeBag)

        input.tableViewSelected.bind(with: self) { owner, value in
            owner.list.append(value.1.movieNm)
            collectionViewList.accept(owner.list)
        }
        .disposed(by: disposeBag)
        
        return Output(tableViewList: list.asDriver(onErrorJustReturn: []), collectionViewList: collectionViewList.asDriver(onErrorJustReturn: []))
    }
}
