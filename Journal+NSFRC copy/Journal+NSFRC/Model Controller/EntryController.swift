//
//  EntryController.swift
//  Journal+NSFRC
//
//  Created by Karl Pfister on 5/9/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
    
    static let sharedInstance = EntryController()
    
    /// create a variable to access our fetched results controller
    var fetchedResultsController: NSFetchedResultsController<Entry>
    
    /// create an intializer that gives our fetchedResultsController a value
    init() {
        
        /// create a fetchRequest in order to fulfill the paramernter requirement of the resultsController;s initializer
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        
        /// accessed the sortDescriptors property on our fetch request and told it we wanted our results sorted by
        /// timestamp in a decending order
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        
        /// created a constant that is a NSFetched ResultsController initialized
         let resultsController: NSFetchedResultsController<Entry> = NSFetchedResultsController(
            fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil
         )
        
        /// assign the results controller to the
        fetchedResultsController = resultsController
        
        /// access the fetchResultsController and then cal performFetch on it
        /// because this might fail, it throws an error if it fails and thus we need to catch
        /// the error if it happens 
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("There was an error performing the fetch request: \(error.localizedDescription)")
        }
        
    }

    //CRUD
    func createEntry(withTitle: String, withBody: String) {
        let _ = Entry(title: withTitle, body: withBody)
        
        saveToPersistentStore()
    }
    
    func updateEntry(entry: Entry, newTitle: String, newBody: String) {
        entry.title = newTitle
        entry.body = newBody
        
        saveToPersistentStore()
    }
    
    func deleteEntry(entry: Entry) {
        entry.managedObjectContext?.delete(entry)
        saveToPersistentStore()
    }
    
    func saveToPersistentStore() {
        do {
             try CoreDataStack.context.save()
        } catch {
            print("Error saving Managed Object. Items not saved!! \(#function) : \(error.localizedDescription)")
        }
    }
}
