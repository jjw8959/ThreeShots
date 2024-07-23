//
//  Extensions.swift
//  ThreeShots
//
//  Created by woong on 6/20/24.
//

import Foundation
import UIKit

extension Date {
    func toString() -> String {
        let df = DateFormatter()
        df.dateFormat = "yy.MM.dd"
        df.timeZone = TimeZone(identifier: "UTC")
        return df.string(from: self)
    }
    func toStringDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd일"
        df.timeZone = TimeZone(identifier: "UTC")
        return df.string(from: self)
    }
}

extension String {
    func toDate() -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yy MM dd"
        df.timeZone = TimeZone(identifier: "UTC")
        if let date = df.date(from: self) {
            return date
        } else {
            return nil
        }
    
    }
}
