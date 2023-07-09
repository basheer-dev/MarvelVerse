//
//  CoreDataManager.swift
//  MarvelVerse
//
//  Created by Basheer Abdulmalik on 09/07/2023.
//

import Foundation
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    enum Entity {
        case Comic
        case Series
        case Event
        case Character
    }
    
    func getSavedComics() -> [SavedComic] {
        var comics: [SavedComic] = []
        
        do {
            comics = try context.fetch(SavedComic.fetchRequest())
        } catch {
            
        }
        
        return comics
    }
    
    func getSavedSeries() -> [SavedSeries] {
        var series: [SavedSeries] = []
        
        do {
            series = try context.fetch(SavedSeries.fetchRequest())
        } catch {
            
        }
        
        return series
    }
    
    func getSavedEvents() -> [SavedEvent] {
        var events: [SavedEvent] = []
        
        do {
            events = try context.fetch(SavedEvent.fetchRequest())
        } catch {
            
        }
        
        return events
    }
    
    func getSavedCharacters() -> [SavedCharacter] {
        var characters: [SavedCharacter] = []
        
        do {
            characters = try context.fetch(SavedCharacter.fetchRequest())
        } catch {
            
        }
        
        return characters
    }
    
    
    func saveObject(type: Entity, id: Int) {
        switch type {
        case .Series:
            if getSavedSeries().contains(where: { $0.id == id }) == false {
                let objectToSave = SavedSeries(context: context)
                objectToSave.id = Int64(id)
            }
            
        case .Event:
            if getSavedEvents().contains(where: { $0.id == id }) == false {
                let objectToSave = SavedEvent(context: context)
                objectToSave.id = Int64(id)
            }
            
        case .Character:
            if getSavedCharacters().contains(where: { $0.id == id }) == false {
                let objectToSave = SavedCharacter(context: context)
                objectToSave.id = Int64(id)
            }
            
        default:
            if getSavedComics().contains(where: { $0.id == id }) == false {
                let objectToSave = SavedComic(context: context)
                objectToSave.id = Int64(id)
            }
        }
        
        saveContext()
    }
    
    func deleteObject(type: Entity, id: Int) {
        switch type {
        case .Series:
            guard let seriesToDelete = getSavedSeries().first(where: { $0.id == id }) else { return }
            context.delete(seriesToDelete)
            
        case .Event:
            guard let eventToDelete = getSavedEvents().first(where: { $0.id == id }) else { return }
            context.delete(eventToDelete)
            
        case .Character:
            guard let characterToDelete = getSavedCharacters().first(where: { $0.id == id }) else { return }
            context.delete(characterToDelete)
            
        default:
            guard let comicToDelete = getSavedComics().first(where: { $0.id == id }) else { return }
            context.delete(comicToDelete)
        }
        
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            
        }
    }
}
