//
//  Extensions.swift
//  ThreePicDiary
//
//  Created by woong on 8/9/24.
//

import UIKit

extension Date {
    func toString(dateFormat format: String = "yyyy.MM.dd") -> String {
        let df = DateFormatter()
        df.timeZone = Calendar.current.timeZone
        df.locale = Locale.autoupdatingCurrent
        df.dateFormat = format
        return df.string(from: self)
    }
}

extension String {
    func toDate(dateFormat format: String = "yyyy.MM.dd") -> Date? {
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.locale = Locale.autoupdatingCurrent
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
        
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1)
        
        return String(self[startIndex ..< endIndex])
    }
}

extension UIFont {
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let descriptor = self.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        return UIFont(descriptor: descriptor, size: 0)    }
}
