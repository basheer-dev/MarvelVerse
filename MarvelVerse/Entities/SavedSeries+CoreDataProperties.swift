//
//  SavedSeries+CoreDataProperties.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 09/07/2023.
//
//

import Foundation
import CoreData


extension SavedSeries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedSeries> {
        return NSFetchRequest<SavedSeries>(entityName: "SavedSeries")
    }

    @NSManaged public var id: Int64

}

extension SavedSeries : Identifiable {

}
