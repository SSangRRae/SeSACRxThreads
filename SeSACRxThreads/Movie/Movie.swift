//
//  Movie.swift
//  SeSACRxThreads
//
//  Created by SangRae Kim on 4/6/24.
//

import Foundation

struct Movie: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [BoxOfficeList]
}

struct BoxOfficeList: Decodable {
    let rank: String
    let movieNm: String
    let openDt: String
}
