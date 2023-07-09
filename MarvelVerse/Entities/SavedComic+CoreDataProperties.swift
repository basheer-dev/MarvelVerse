//
//  SavedComic+CoreDataProperties.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 09/07/2023.
//
//

import Foundation
import CoreData


extension SavedComic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedComic> {
        return NSFetchRequest<SavedComic>(entityName: "SavedComic")
    }

    @NSManaged public var id: Int64

}

extension SavedComic : Identifiable {

}
