//
//  SavedCharacter+CoreDataProperties.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 09/07/2023.
//
//

import Foundation
import CoreData


extension SavedCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedCharacter> {
        return NSFetchRequest<SavedCharacter>(entityName: "SavedCharacter")
    }

    @NSManaged public var id: Int64

}

extension SavedCharacter : Identifiable {

}
