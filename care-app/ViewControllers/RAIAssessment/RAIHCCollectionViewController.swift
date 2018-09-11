//
//  RAIHCCollectionViewController.swift
//  care-app
//
//  Created by De MicheliStefano on 10.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

private let reuseIdentifier = "AssessmentCell"
let assessment: [String: String] = ["type": "ordinal-scale-cell"]

class RAIHCCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(OrdinalScaleCollectionViewCell.self, forCellWithReuseIdentifier: "ordinal-scale-cell")
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Do a switch statement based on the type of the question
        // set collectionviewcell and reuseidentifier
        // let collectionViewCell = OrdinalScaleCollectionViewCell
        
//        let assessmentComponent = assessment[indexPath.item]
//
//        switch assessmentComponent.type {
//        case "ordinal-scale-cell":
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ordinal-scale-cell", for: indexPath) as! OrdinalScaleCollectionViewCell
//            cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.green
//            return cell
//
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ordinal-scale-cell", for: indexPath) as! OrdinalScaleCollectionViewCell
//            cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.green
//            return cell
//        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ordinal-scale-cell", for: indexPath) as! OrdinalScaleCollectionViewCell
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */

}

extension RAIHCCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
