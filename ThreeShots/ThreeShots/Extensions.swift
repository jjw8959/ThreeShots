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
        df.dateFormat = "yy MM dd"
        if let date = df.date(from: self) {
            return date
        } else {
            return nil
        }
    
    }
}
