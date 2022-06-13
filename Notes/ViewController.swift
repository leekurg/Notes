//
//  ViewController.swift
//  Notes
//
//  Created by Ильяяя on 05.06.2022.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    private var notesModel: [NoteDataModel] = []
//    private var notesModel: [NoteDataModel] = [
//        NoteDataModel(id: 1,
//                      timestamp: Date(),
//                      title: "Title 1",
//                      description: "note 1",
//                      color: UIColor(red: 224/255, green: 236/255, blue: 255/255, alpha: 1).cgColor ) ,
//        NoteDataModel(id: 2,
//                      timestamp: Date(),
//                      title: "Views",
//                      description: "Views can host other views. Embedding one view inside another creates a containment relationship between the host view (known as the superview) and the embedded view (known as the subview). View hierarchies make it easier to manage views.",
//                      color: UIColor(red: 233/255, green: 245/255, blue: 223/255, alpha: 1).cgColor ),
//
//        NoteDataModel(id: 3,
//                      timestamp: Date(),
//                      title: "Building blocks",
//                      description: "Views and controls are the visual building blocks of your app’s user interface. Use them to draw and organize your app’s content onscreen.",
//                      color: UIColor(red: 240/255, green: 225/255, blue: 245/255, alpha: 1).cgColor ),
//        NoteDataModel(id: 4,
//                      timestamp: Date(),
//                      title: "Title 4",
//                      description: "note 4",
//                      color: UIColor(red: 240/255, green: 227/255, blue: 209/255, alpha: 1 ).cgColor),
//        NoteDataModel(id: 5,
//                      timestamp: Date(),
//                      title: "Title 5",
//                      description: "note 5",
//                      color: UIColor(red: 255/255, green: 200/255, blue: 200/255, alpha: 1 ).cgColor)
//    ]
    
    private let preferWidthNoteItem: CGFloat = 160
    private let preferPaddingNoteItem: CGFloat = 20
    
    private var timerSearchDelay: Timer?
    
    private var collectionView: UICollectionView!
    private var stackViewBar: UIStackView!
    private var stackViewCollection: UIStackView!
    private var searchBar: UISearchBar!
    private var toolBar: UIToolbar!
    private var buttonSuper: UIButton!
    
    private var isSearching = false
    private var lpgr: UILongPressGestureRecognizer!
    private var _IsSelectionMode = false
    private var isSelectionMode: Bool {
        set {
            _IsSelectionMode = newValue
            if _IsSelectionMode {
                let color = #colorLiteral(red: 1, green: 0.7351920009, blue: 0.7335172296, alpha: 1)
                animateCollectionTransition(toColor: color)
            }
            else {
                animateCollectionTransition(toColor: .white)
            }
            animateBarSwitch()
            animateSuperButtonTransition(forward: _IsSelectionMode)
        }
        get {
            return _IsSelectionMode
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        setupToolBar()
        setupCollectionView()
        setupSuperButton()
        setupLongGesture()
        
        reloadData()
    }

    
    //MARK: - Setup UI
    private func setupToolBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        toolBar = UIToolbar()
        var items = [UIBarButtonItem]()
        let buttonSelect: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle( "Select all", for: .normal)
            return button
        }()
        buttonSelect.addTarget(self, action: #selector(selectAllDidTouched), for: .touchUpInside)
        
        let labelSelect: UILabel = {
            let label = UILabel()
            label.text = "Select notes"
            label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            return label
        }()
        items.append(
            UIBarButtonItem(customView: buttonSelect)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        )
        items.append(
            UIBarButtonItem(customView: labelSelect)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelectionDidTouched))
        )
        toolBar.setItems(items, animated: true)
        
        stackViewBar = UIStackView(arrangedSubviews: [toolBar, searchBar])
        stackViewBar.axis = .vertical
        
        view.addSubview(stackViewBar)
        
        stackViewBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        searchBar.isHidden = true
        toolBar.isHidden = true
    }
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        
        collectionView.register(NoteCell.self, forCellWithReuseIdentifier: NoteCell.reuseID)
        collectionView.register(NoteSection.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: NoteSection.reuseID)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        collectionView.contentInsetAdjustmentBehavior = .automatic
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let noContentView: UIView = {
            let view = UIView()
            
            let labelTitle = UILabel()
            labelTitle.text = "No content yet"
            labelTitle.textColor = .lightGray
            labelTitle.font = UIFont.systemFont(ofSize: 25, weight: .bold)
            
            let labelDesc = UILabel()
            labelDesc.text = "No notes has been created yet"
            labelDesc.textColor = .lightGray
            
            view.addSubview(labelTitle)
            view.addSubview(labelDesc)
            
            labelTitle.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-50)
            }
            
            labelDesc.snp.makeConstraints { make in
                make.top.equalTo(labelTitle.snp.bottom)
                make.centerX.equalTo(labelTitle)
            }
            
            return view
        }()
        
        stackViewCollection = UIStackView(arrangedSubviews: [collectionView, noContentView])
        stackViewCollection.axis = .vertical
        
        view.addSubview(stackViewCollection)
        
        stackViewCollection.snp.makeConstraints { make in
            make.top.equalTo(self.stackViewBar.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        collectionView.isHidden = true
    }
    
    private func setupSuperButton() {
        
        buttonSuper = {
            let button = UIButton(type: .system)
            let cornerR: CGFloat = 30
            button.layer.cornerRadius = cornerR
            button.setImage(UIImage(systemName: "plus" )?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)), for: .normal)
            button.layer.shadowOffset = CGSize(width: 15, height: 15)
            button.layer.shadowOpacity = 0.3
            button.layer.shadowRadius = 10
            button.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
            
            button.addBlurEffect(style: .light, cornerRadius: cornerR, padding: 0)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.4324872494, blue: 0, alpha: 0.480598096)
            return button
        }()
        
        view.addSubview(buttonSuper)

        buttonSuper.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(20)
            make.width.height.equalTo(60)
        }

        buttonSuper.addTarget(self, action: #selector(didSuperButtonTouched), for: .touchUpInside)
        
    }
    
    private func setupLongGesture() {
        lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.delaysTouchesBegan = true
        lpgr.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(lpgr)
    }
    
    //MARK: - Action
    @objc private func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }

        let p = gesture.location(in: self.collectionView)

        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            let cell = self.collectionView.cellForItem(at: indexPath) as! NoteCell
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            cell.setSelected()
            isSelectionMode = true
        }
    }
    
    @objc private func didSuperButtonTouched() {
        animateButtonPressed(button: buttonSuper)
        isSelectionMode ? deleteSelectedNotes() : showNewNoteController()
    }
    
    private func showNewNoteController() {
        let noteEditView = NoteEditViewController()
        noteEditView.informParentWhenDone = { [weak self] in
            self?.reloadData()
        }
        present(noteEditView, animated: true)
    }
    
    private func deleteSelectedNotes() {
        let indexPaths = collectionView.indexPathsForSelectedItems
        
        guard let indexPaths = indexPaths else {
            return
        }

        let alert = UIAlertController(title: "Removing", message: "\(indexPaths.count) note(s) will be removerd. Are you sure?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            
            let listId = indexPaths.map { index in self.notesModel[index.row].id }
            let success = database.remove(listId: listId)
            if !success {
                self.showAlert(title: "Error", text: "Unable to delete from database")
                self.isSelectionMode = false
                return
            }

            self.collectionView!.performBatchUpdates({
                self.reloadData()
            }, completion: nil)
            
            self.isSelectionMode = false
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
        
    }
    
    @objc private func selectAllDidTouched() {
        print(#function)    //TODO
    }
    
    @objc private func cancelSelectionDidTouched() {
//        defer {
            isSelectionMode = false
//        }
        
        let selectedItems = collectionView.indexPathsForSelectedItems
        guard let selectedItems = selectedItems else {
            return
        }

        for index in selectedItems {
            collectionView.deselectItem(at: index, animated: true)
            if let cell = collectionView.cellForItem(at: index) as? NoteCell {
                cell.setSelected( selected: false )
             }
         }
    }
    
    //MARK: - Animation
    private func animateCollectionTransition( toColor color: UIColor ) {
        UIView.transition(with: collectionView, duration: 0.5, options: .transitionCrossDissolve,
                          animations: { self.collectionView.backgroundColor = color },
                          completion: nil
        )
    }
    
    private func animateSuperButtonTransition( forward: Bool = true ) {
        if forward {
            buttonSuper.setImage(UIImage(systemName: "trash.fill" )?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        }
        else {
            buttonSuper.setImage(
                UIImage(systemName: "plus" )?.withTintColor(.white, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)), for: .normal)
        }
        
        UIView.transition(with: buttonSuper, duration: 0.5, options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.buttonSuper.backgroundColor = forward ? .red : #colorLiteral(red: 1, green: 0.4324872494, blue: 0, alpha: 0.480598096) },
                          completion: nil
        )
    }
    
    private func animateBarSwitch() {
        UIView.transition(with: searchBar, duration: 0.3, options: .transitionCrossDissolve,
                          animations: { [weak self] in self?.switchStackView(stack: self?.stackViewBar) },
                          completion: nil
        )
    }
    
    private func animateButtonPressed( button: UIButton ) {

            button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)

            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(10.0),
                           initialSpringVelocity: CGFloat(4.0),
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: {
                                button.transform = CGAffineTransform.identity
                            },
                           completion: { Void in()  }
            )
    }
}
   


    //MARK: - Data source
extension ViewController: UICollectionViewDataSource {
    
    //section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesModel.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NoteSection.reuseID, for: indexPath) as! NoteSection
        header.titleLabel.text = "SECTION"
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 40)
    }
    
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCell.reuseID, for: indexPath) as! NoteCell
        cell.titleLabel.text = notesModel[indexPath.item].title
        if cell.titleLabel.text.isEmpty { cell.setTitleHidden() }
        
        
        if var text = notesModel[indexPath.item].description {
            text = text.trimmingCharacters(in: .newlines)
            cell.descLabel.text = text
        }
        
        cell.backgroundColor = NoteColors.getColor(name: notesModel[indexPath.item].color)
        return cell
    }
    
    
    func reloadData( at index: IndexPath? = nil ) {
        
        collectionView.performBatchUpdates() { [weak self] in
            guard let self = self else { return }
            
            self.notesModel = database.read()
            
            //init state: there is data, collection hidden
            if self.notesModel.count > 0 && self.collectionView.isHidden {
                switchStackView(stack: stackViewCollection)
                searchBar.isHidden = false
            }
            //just deleted last note
            else if self.notesModel.count == 0 && !self.collectionView.isHidden
            {
                switchStackView(stack: stackViewCollection)
            }
            
            if let index = index {
                self.collectionView.reloadItems(at: [index])
            }
            else {
                self.collectionView.reloadData()
            }
        }
        print("Notes in db: \(notesModel.count)")
    }
    
    func reloadDataForQuery( query: String? )
    {
        guard let len = query?.count, len > 2 else {
            isSearching = false
            reloadData()
            return
        }
        
        isSearching = true
        collectionView.performBatchUpdates() { [weak self] in
            guard let self = self else { return }
            
            self.notesModel = database.search(query: query)
            
            if self.notesModel.count > 0 && self.collectionView.isHidden {
                switchStackView(stack: stackViewCollection)
            }
            else if self.notesModel.count == 0 && !self.collectionView.isHidden
            {
                switchStackView(stack: stackViewCollection)
            }

        }
        print("Notes by search '\(String(describing: query))': \(notesModel.count)")
    }
}

//MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    
    //Higlightion
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NoteCell {
            cell.setHighlighted()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NoteCell {
            cell.setHighlighted(highlighted: false)
        }
    }
    
    // Selection
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let _ = collectionView.cellForItem(at: indexPath) as? NoteCell {
            if isSelectionMode == false {
                let noteEditView = NoteEditViewController(model: notesModel[indexPath.item])
                noteEditView.informParentWhenDone = { [weak self] in
                    self?.reloadData( at: indexPath )
                }
                present(noteEditView, animated: true)
                return false
            }
            else {
                return true
            }
        }
        
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NoteCell {
            cell.setSelected()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NoteCell {
            cell.setSelected(selected: false)
            if collectionView.indexPathsForSelectedItems?.count == 0 {
                isSelectionMode = false
            }
            
        }
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let paddingSpace = 20 * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//        let height = widthPerItem
////        if( note.text > 100 ) height = 2 * width...
//
//        return CGSize(width: widthPerItem, height: height)
//    }
    
    func calcWidthPerItem( preferWidth: CGFloat, preferPadding: CGFloat ) -> CGFloat {
        var items = view.frame.width / ( preferWidth + preferPadding )
        items = items.rounded(.down)
        let width = (view.frame.width - preferPadding * (items+1)) / items

        return width
    }
    
    func calcHeightPerItem( width: CGFloat, text: String? ) -> CGFloat {
        guard let text = text else {
            return width * 0.5
        }

        let n = text.components(separatedBy:"\n").count - 1

        let weigth = text.count + n * 14
        
        if weigth < 30 {    return width * 0.5  }
        else if weigth > 80 {   return width * 1.5  }
        

        return width
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
//        if UIDevice.current.orientation.isLandscape {
//
//        }

        let widthPerItem = calcWidthPerItem(preferWidth: preferWidthNoteItem, preferPadding: preferPaddingNoteItem)
        let height = widthPerItem/*calcHeightPerItem(width: widthPerItem, text: notesModel[indexPath.item].description)*/
        
        return CGSize(width: widthPerItem, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let timer = timerSearchDelay {   timer.invalidate()  }
        
        timerSearchDelay = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.reloadDataForQuery(query: searchText)
        }
    }
}


//MARK: - Other

extension ViewController {
    private func showAlert( title: String, text: String ) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func switchStackView( stack: UIStackView? ) {
        guard let stack = stack else { return }
        
        func reverseViewHiddenProp( view: UIView? ) {
            if let v = view {   v.isHidden = !v.isHidden    }
        }
        
        reverseViewHiddenProp(view: stack.arrangedSubviews.first)
        reverseViewHiddenProp(view: stack.arrangedSubviews.last)
    }
}
