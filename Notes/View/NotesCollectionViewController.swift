//
//  NotesCollectionViewController.swift
//  Notes
//
//  Created by Ильяяя on 05.06.2022.
//

import UIKit

class NotesCollectionViewController: UICollectionViewController {
    
    private var notesModel: [NoteDataModel] = [NoteDataModel(title: "Title 1", description: "note 1", color: UIColor(red: 224/255, green: 236/255, blue: 255/255, alpha: 1).cgColor, timestamp: Date() ) ,
                                               NoteDataModel(title: "Views", description: "Views can host other views. Embedding one view inside another creates a containment relationship between the host view (known as the superview) and the embedded view (known as the subview). View hierarchies make it easier to manage views.", timestamp: Date()),
                                               NoteDataModel(title: "Building blocks", description: "Views and controls are the visual building blocks of your app’s user interface. Use them to draw and organize your app’s content onscreen.", timestamp: Date()),
                                               NoteDataModel(title: "Title 4", description: "note 4", color: UIColor(red: 240/255, green: 227/255, blue: 209/255, alpha: 1 ).cgColor, timestamp: Date()),
                                               NoteDataModel(title: "Title 5", description: "note 5", color: UIColor(red: 255/255, green: 200/255, blue: 200/255, alpha: 1 ).cgColor, timestamp: Date())]
    private let itemsPerRow: CGFloat = 2

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
//        setupLongGesture()
    }
    
    //MARK: - Setup UI
    private func setupCollectionView() {
        collectionView.register(NoteCell.self, forCellWithReuseIdentifier: NoteCell.reuseID)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) //TODO (replace to directionalLayoutMargins )
//        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
//    private func setupLongGesture() {
//        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
//        lpgr.delaysTouchesBegan = true
//        lpgr.minimumPressDuration = 0.5
//        collectionView.addGestureRecognizer(lpgr)
//    }
    
    
    
    //MARK: - Data source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesModel.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCell.reuseID, for: indexPath) as! NoteCell
        cell.titleLabel.text = notesModel[indexPath.item].title
        cell.descLabel.text = notesModel[indexPath.item].description
        cell.setBackgroundColor(color: notesModel[indexPath.item].color)
        return cell
    }
    
//    //MARK: - Action
//    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
//        if gesture.state != .ended {
//            return
//        }
//
//        let p = gesture.location(in: self.collectionView)
//
//        if let indexPath = self.collectionView.indexPathForItem(at: p) {
//            let cell = self.collectionView.cellForItem(at: indexPath) as! NoteCell
//            cell.setSelected()
//        } else {
//            fatalError("couldn't find index path")
//        }
//    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NotesCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = 20 * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = widthPerItem
//        if( note.text > 100 ) height = 2 * width...
        
        return CGSize(width: widthPerItem, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

//MARK: - UICollectionViewDelegate
extension NotesCollectionViewController {
    
    //Higlightion
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NoteCell {
            cell.setHighlighted()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NoteCell {
            cell.setHighlighted(highlighted: false)
        }
    }
    
    // Selection
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NoteCell {
            cell.setSelected()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NoteCell {
            cell.setSelected(selected: false)
        }
    }
}
