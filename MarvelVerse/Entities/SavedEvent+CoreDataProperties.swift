//
//  SavedEvent+CoreDataProperties.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 09/07/2023.
//
//

import Foundation
import CoreData


extension SavedEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedEvent> {
        return NSFetchRequest<SavedEvent>(entityName: "SavedEvent")
    }

    @NSManaged public var id: Int64

}

extension SavedEvent : Identifiable {

}
