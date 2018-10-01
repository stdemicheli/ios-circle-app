//
//  RAIHCCollectionViewController.swift
//  care-app
//
//  Created by De MicheliStefano on 10.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import CoreData

class RAIHCCollectionViewController: UICollectionViewController, RAIAssessmentCollectionViewCellDelegate {
    
    // MARK: - Properties
    
    let assessmentController = AssessmentController()
    private let reuseIdentifier = "RAIAssessmentCell"
    private var cellSize: CGSize!
    
    lazy var frc: NSFetchedResultsController<Question> = {
        let fetchRequest: NSFetchRequest<Question> = Question.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sectionId", ascending: true), NSSortDescriptor(key: "id", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "assessment.type == %@", AssessmentType.raiHC.rawValue)
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    var blockOperations: [BlockOperation] = []
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(RAIAssessmentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        
        if frc.fetchedObjects?.count == 0 {
            assessmentController.fetchAssessment(for: AssessmentType.raiHC) { (error) in
                if let error = error {
                    NSLog("Error fetching RAI HC Assessment: \(error)")
                    return
                }
            }
        }
    }
    
    deinit {
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    // MARK: RAIAssessmentCollectionViewCellProtocol
    
    func openMenu() {
        guard let questions = frc.fetchedObjects else { return }
        let RAIAssessmentMenu = RAIAssessmentMenuViewController(questions: questions)
        RAIAssessmentMenu.delegate = self

        self.present(RAIAssessmentMenu, animated: true, completion: nil)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func next() {
        let contentOffset = collectionView.contentOffset
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width,
                                                  y: contentOffset.y,
                                                  width: cellSize.width,
                                                  height: cellSize.height), animated: true)
    }
    
    func previous() {
        let contentOffset = collectionView.contentOffset
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x - cellSize.width,
                                                  y: contentOffset.y,
                                                  width: cellSize.width,
                                                  height: cellSize.height), animated: true)
    }
    
    func goToCell(with id: String) {
        dismiss()
        let contentOffset = collectionView.contentOffset
        guard let index = getIndex(for: id) else { NSLog("Could not get index for id: \(id)"); return }
        collectionView.scrollRectToVisible(CGRect(x: CGFloat(index) * cellSize.width,
                                                  y: contentOffset.y,
                                                  width: cellSize.width,
                                                  height: cellSize.height), animated: true)
    }
    
    func select(_ response: Response, in cell: RAIAssessmentCollectionViewCell) {
        if let question = cell.question {
            assessmentController.select(response, in: question)
        }
    }
    
    func respond(with input: String, for response: Response, in cell: RAIAssessmentCollectionViewCell) {
        if let question = cell.question {
            assessmentController.respond(with: input, for: response, in: question)
        }
    }
    
    private func getIndex(for id: String) -> Int? {
        //TODO: refactor questions
        guard let questions = frc.fetchedObjects else { return nil }
        for (index, question) in questions.enumerated() {
            if id == question.id { return index }
        }
        return nil
    }
    
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frc.fetchedObjects?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RAIAssessmentCollectionViewCell
        cell.delegate = self
        
        let question = frc.object(at: indexPath)
        cell.question = question
        
        cell.currentQuestionIndex = indexPath.item + 1
        cell.totalQuestionsCount = frc.fetchedObjects?.count ?? 0
        
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.green
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

// MARK: - UICollectionViewDelegateFlowLayout

extension RAIHCCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

// MARK: - NSFetchedResultsControllerDelegate

extension RAIHCCollectionViewController: NSFetchedResultsControllerDelegate {
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == NSFetchedResultsChangeType.update {
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadItems(at: [indexPath!])
                    }
                })
            )
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        if type == NSFetchedResultsChangeType.update {
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        this.collectionView!.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
                    }
                })
            )
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView!.performBatchUpdates({ () -> Void in
            for operation: BlockOperation in self.blockOperations {
                operation.start()
            }
        }, completion: { (finished) -> Void in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
    
}
