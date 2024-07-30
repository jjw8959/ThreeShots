//
//  DiaryStruct.swift
//  ThreeShots
//
//  Created by woong on 6/27/24.
//

import Foundation

struct DiaryStruct: Identifiable {
    var id: String = UUID().uuidString
    let date: Date
    let firstImage: String
    let secondImage: String
    let thridImage: String
    let content: String
}
