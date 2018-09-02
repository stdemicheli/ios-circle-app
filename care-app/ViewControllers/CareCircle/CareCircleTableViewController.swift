//
//  CareRecipientTableViewController.swift
//  care-app
//
//  Created by De MicheliStefano on 28.07.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import CoreData

class CareRecipientTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    
    let careCircleController = CareCircleController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Member> = {
        let fetchRequest: NSFetchRequest<Member> = Member.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: "type", ascending: false), NSSortDescriptor(key: "name", ascending: false)]
        fetchRequest.sortDescriptors = sortDescriptors
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "type",
                                             cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // NSFetchedResultsController
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let newIndexPath = newIndexPath, let oldIndexPath = indexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CareCircleCell", for: indexPath)

        let careCircleMember = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = careCircleMember.name
        cell.detailTextLabel?.text = careCircleMember.city
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let careCircleMember = fetchedResultsController.object(at: indexPath)
            
            do {
                try careCircleController.remove(member: careCircleMember)
            } catch {
                // If deletion doesn't succeed then reset the moc and reload the tableView
                let moc = CoreDataStack.shared.mainContext
                moc.reset()
                tableView.reloadData()
            }
        }
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddCareCircleModal" {
            guard let modalVC = segue.destination as? AddCareCircleViewController else { return }
            modalVC.careCircleController = careCircleController
        } else if segue.identifier == "ShowProfileDetail" {
            guard let detailVC = segue.destination as? CareCircleDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            
            detailVC.careCircleController = careCircleController
            detailVC.member = fetchedResultsController.object(at: indexPath)
            
        }
    }

}
