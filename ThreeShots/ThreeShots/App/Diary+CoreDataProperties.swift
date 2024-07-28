//
//  Diary+CoreDataProperties.swift
//  ThreeShots
//
//  Created by woong on 7/29/24.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var date: String?
    @NSManaged public var content: String?
    @NSManaged public var firstImage: String?
    @NSManaged public var secondImage: String?
    @NSManaged public var thirdImage: String?
    @NSManaged public var id: UUID?

}

extension Diary : Identifiable {

}
