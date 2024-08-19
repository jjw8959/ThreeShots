//
//  Extensions.swift
//  ThreePicDiary
//
//  Created by woong on 8/9/24.
//

import Foundation

extension Date {
    func toString(dateFormat format: String = "yyyy.MM.dd") -> String {
        let df = DateFormatter()
        df.timeZone = Calendar.current.timeZone
        df.dateFormat = format
        return df.string(from: self)
    }
}

extension String {
    func toDate(dateFormat format: String = "yyyy.MM.dd") -> Date? {
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.dateFormat = format
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
