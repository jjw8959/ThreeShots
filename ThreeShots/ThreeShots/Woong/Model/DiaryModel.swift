//
//  DiaryModel.swift
//  ThreeShots
//
//  Created by woong on 6/27/24.
//

import Foundation

struct DiaryModel {
    
    var diarys: [DiaryStruct] = []
    
    init() {
        diarys = [
            DiaryStruct(date: Date(), title: "오늘은 무슨 일기를 써볼까",  firstImage: "mock1", secondImage: "mock2", thridImage: "mock3", content: "지금이라면 다진고기로 만들 수 있습니다. 녀석들이 날 갖고서 모두 부장까지! 이런 꼴을 당하지 않으면 안되는 거냐고!", bestImage: .first),
            DiaryStruct(date: Date(), title: "I have Big Gun", firstImage: "mock1", secondImage: "mock2", thridImage: "mock3", content: "It's all up to you.", bestImage: .second),
            DiaryStruct(date: Date(), title: "Light up on fire.", firstImage: "mock1", secondImage: "mock2", thridImage: "mock3", content: "Weapon.. I have it all!", bestImage: .third),
            
        ]
    }
}
