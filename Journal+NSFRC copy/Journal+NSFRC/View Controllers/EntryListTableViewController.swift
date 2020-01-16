//
//  EntryListTableViewController.swift
//  Journal+NSFRC
//
//  Created by Karl Pfister on 5/9/19.
//  Copyright © 2019 Karl Pfister. All rights reserved.
//

import UIKit
import CoreData

class EntryListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EntryController.sharedInstance.fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        EntryController.sharedInstance.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)

        guard let entry = EntryController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row], let entryDate = entry.timestamp else { return UITableViewCell() }
        
        let formattedEntryDate = DateFormatter.localizedString(from: entryDate, dateStyle: .short, timeStyle: .short)
        
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = formattedEntryDate
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let entry = EntryController.sharedInstance.fetchedResultsController.fetchedObjects?[indexPath.row] else { return }
            EntryController.sharedInstance.deleteEntry(entry:entry)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        if segue.identifier == "toDetailView" {
            guard let selectedIndexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? EntryDetailViewController else { return}
            
            let entry = EntryController.sharedInstance.fetchedResultsController.fetchedObjects?[selectedIndexPath.row]
            
            destinationVC.entry = entry
        }
    }
}

extension EntryListTableViewController: NSFetchedResultsControllerDelegate {
    
    //conform to NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .delete:
                guard let indexPath = indexPath else { break }
                tableView.deleteRows(at: [indexPath], with: .fade)
            case .insert:
                guard let newIndexPath = newIndexPath else { break }
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            case .move:
                guard let indexPath = indexPath, let newIndexPath = newIndexPath else { break }
                tableView.moveRow(at: indexPath, to: newIndexPath)
            case .update:
                guard let indexPath = indexPath else { break }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            
            @unknown default:
                fatalError()
        }
        
    }
    
    
}
