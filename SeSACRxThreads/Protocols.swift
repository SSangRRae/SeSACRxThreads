//
//  Protocols.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/4/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    func transform(_ input: Input) -> Output
}
