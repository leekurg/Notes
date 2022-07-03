//
//  ViewController.swift
//  Notes
//
//  Created by Ильяяя on 05.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var notesModel: NotesDataModel!
    
    private let preferWidthNI: CGFloat = 160
    private let preferPaddingNIPortrait: CGFloat = 20
    private let preferPaddingNILandscape: CGFloat = 50
    
    private var timerSearchDelay: Timer?
    
    private var collectionView: UICollectionView!
    private var stackViewCollection: UIStackView!
    private var searchController = UISearchController(searchResultsController: nil)
    private var buttonSuper: UIButton!
    
    private var isSearching = false {
        didSet {
            animateSuperButtonHide(hide: isSearching)
        }
    }
    private var lpgr: UILongPressGestureRecognizer!
    private var _IsSelectionMode = false
    private var isSelectionMode: Bool {
        set {
            _IsSelectionMode = newValue
            if _IsSelectionMode {
                animateCollectionTransition(toColor: UIColor(red: 1, green: 0.73, blue: 0.73, alpha: 0.3))
                setToolBarSelect()
            }
            else {
                animateCollectionTransition(toColor: .white)
                setToolBarSearch()
            }
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
        
        //quick action
        if let _ = passedShortcut {
            showNoteController()
        }
    }

    
    //MARK: - Setup UI
    private func setupToolBar() {
        navigationItem.title = "Notes"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        
        setToolBarSearch()
    }
    
    private func setToolBarSearch() {
        navigationItem.setLeftBarButton(nil, animated: true)
        navigationItem.setRightBarButton(nil, animated: true)
    }
    
    private func setToolBarSelect() {
        let buttonPin: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle( "Pin", for: .normal)
            button.setImage(UIImage(systemName: "pin.fill" )?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17, weight: .light, scale: .medium)), for: .normal)
            return button
        }()
        buttonPin.addTarget(self, action: #selector(pinDidTouched), for: .touchUpInside)
        navigationItem.setLeftBarButtonItems([UIBarButtonItem(customView: buttonPin)], animated: true)
        
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelectionDidTouched)), animated: true)
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
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let noContentView = NoContentView()
        noContentView.configure()
        
        stackViewCollection = UIStackView(arrangedSubviews: [collectionView, noContentView])
        stackViewCollection.axis = .vertical
        
        view.addSubview(stackViewCollection)
        
        stackViewCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.isHidden = true
    }
    
    private func setupSuperButton() {
        buttonSuper = UIButton.createSuperButton(cornerRadius: 30)
        
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

        if searchController.isActive { return }
        
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
        isSelectionMode ? deleteSelectedNotes() : showNoteController()
    }
    
    func showNoteController(id: String?) {
        showNoteController(model: notesModel?.getNote(withId: id)) 
    }
    
    func showNoteController(model: NoteDataModel? = nil) {
        if let nevc = presentedViewController as? NoteEditViewController {
            if let id = model?.id, id != nevc.getNoteId() {
                presentedViewController?.dismiss(animated: true)
            }
        }
        
        let noteEditView = NoteEditViewController(model: model)
        noteEditView.informParentWhenDone = { [weak self] in
            self?.reloadData(query: self?.searchController.searchBar.text)
        }
        present(noteEditView, animated: true)
    }
    
    func handleScheduledNotification(id: String?) {
        guard let _ = id, let id = Int(id!) else { return }
        
        let note = notesModel?.getNote(withId: id)
        if let note = note {
            //if editing note
            if let nevc = presentedViewController as? NoteEditViewController {
                if note.id == nevc.getNoteId() {
                    nevc.didScheduled(date: nil)
                }
            }
        }
        
        database.updateUnschedule(listId: [id])
        if isSearching && note == nil
        {}
        else if isSelectionMode
        {
//            if let list = collectionView.indexPathsForSelectedItems {
//                reloadData()
//                for path in list {
//                    let cell = collectionView.cellForItem(at: path) as? NoteCell
//                    cell?.setSelected()
//                }
//            }
        }
        else {
            reloadData(query: searchController.searchBar.text)    //TODO if search? if editing? deleting notes
        }
    }
    
    private func deleteSelectedNotes() {
        let indexPaths = collectionView.indexPathsForSelectedItems

        guard let indexPaths = indexPaths else {
            return
        }

        let alert = UIAlertController(title: "Removing", message: "\(indexPaths.count) note(s) will be removerd. Are you sure?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }

            let listOptId = indexPaths.map { index in self.notesModel[index]?.id }
            let listId = listOptId.compactMap { $0 }
            
            let success = database.remove(listId: listId)
            if !success {
                self.showAlert(title: "Error", text: "Unable to delete from database")
                self.isSelectionMode = false
                return
            }

            self.reloadData()
            
            self.isSelectionMode = false
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    
    @objc private func pinDidTouched() {
        let indexPaths = collectionView.indexPathsForSelectedItems

        guard let indexPaths = indexPaths else {
            return
        }
        
        let listOptId = indexPaths.map { index in self.notesModel[index]?.id }
        let listId = listOptId.compactMap { $0 }
        
        database.updatePin(listId: listId)
        reloadData()
        isSelectionMode = false
    }
    
    @objc private func cancelSelectionDidTouched() {

        isSelectionMode = false
        
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
    
    private func animateSuperButtonHide( hide: Bool ) {
        UIView.transition(with: buttonSuper, duration: 0.5, options: .transitionCrossDissolve,
                          animations: { self.buttonSuper.isHidden = hide },
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
        return notesModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < notesModel.sections.count {
            return notesModel.sections[section].notes.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NoteSection.reuseID, for: indexPath) as! NoteSection
        
        header.titleLabel.text = notesModel.sections[indexPath.section].name.capitalized + " (\(notesModel.sections[indexPath.section].notes.count))"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if notesModel.sections[section].name == NoteCategory.pinned.rawValue {
            return CGSize(width: view.frame.size.width, height: 0)
        }
        
        return CGSize(width: view.frame.size.width, height: 40)
    }
    
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoteCell.reuseID, for: indexPath) as! NoteCell
        cell.titleLabel.text = notesModel[indexPath]?.title
        
        if cell.titleLabel.text.isEmpty { cell.setTitleHidden() }
        
        if var text = notesModel[indexPath]?.description {
            text = text.trimmingCharacters(in: .newlines)
            cell.descLabel.text = text
        }
        
        if let pinned = notesModel[indexPath]?.pinned, pinned == true {
            cell.pinMark.alpha = 1
        }
        
        if let scheduled = notesModel[indexPath]?.scheduled, scheduled > .now {
            cell.setDate(date: scheduled)
        }
        
        cell.backgroundColor = NoteColors.getColor(name: notesModel[indexPath]?.color)
        return cell
    }
    
    func reloadData(atIndexPaths indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }
    
    func reloadData( query: String? = nil )
    {
        if let len = query?.count, len > 2 {
            isSearching = true
        }
        else {
            isSearching = false
        }

        notesModel = isSearching ? database.read(query: query) : database.read()

        if notesModel.count > 0 && self.collectionView.isHidden {
            switchStackView(stack: stackViewCollection)
        }
        else if self.notesModel.count == 0 && !self.collectionView.isHidden
        {
            switchStackView(stack: stackViewCollection)
        }

        collectionView.reloadData()
        print("Notes shown: \(notesModel.allCount)")
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
                showNoteController(model: notesModel[indexPath])
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
        let sideInset: CGFloat = Orientation.isPortrait ? preferPaddingNIPortrait : preferPaddingNILandscape
        let width = (view.frame.width - preferPadding * (items-1) - 2 * sideInset) / items

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

        let widthPerItem = calcWidthPerItem(preferWidth: preferWidthNI, preferPadding: preferPaddingNIPortrait)
        let height = widthPerItem /*calcHeightPerItem(width: widthPerItem, text: notesModelWithCat.notes[indexPath.item].description)*/
        
        return CGSize(width: widthPerItem, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset = Orientation.isPortrait ? preferPaddingNIPortrait : preferPaddingNILandscape
        return UIEdgeInsets(top: 20, left: sideInset, bottom: 20, right: sideInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return preferPaddingNIPortrait
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let timer = timerSearchDelay {   timer.invalidate()  }
        
        timerSearchDelay = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.reloadData(query: searchText)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if isSelectionMode {
            cancelSelectionDidTouched()
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reloadData()
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
