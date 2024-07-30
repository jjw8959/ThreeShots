//
//  Extensions.swift
//  ThreeShots
//
//  Created by woong on 6/20/24.
//

import Foundation
import UIKit

extension Date {
    func toString(dateFormat format: String = "yyyy.MM.dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String {
    func toDate() -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy.MM.dd"
        if let date = df.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        return String(self[startIndex ..< endIndex])
    }
}
