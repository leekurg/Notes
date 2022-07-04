
//  NoteEditViewController.swift
//  Notes
//
//  Created by Ильяяя on 06.06.2022.
//

import UIKit
import SnapKit

class NoteEditViewController: UIViewController {
    
    private var controlPanel: NoteEditControlPanel!
    private var textPanel: NoteEditTextPanel!
    private var backView: UIView!
    
    private var model: NoteDataModel!
    private var oldModel : NoteDataModel!
    private var isNew = false
    
    var informParentWhenDone: (() -> Void)?
    
    init( model _model: NoteDataModel? = nil ) {
        if _model == nil {
            isNew = true
            
            let id = database.lastId ?? 0
            model = NoteDataModel(id: id + 1)
        }
        else {
            model = _model
        }
        
        oldModel = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        print("Shown note id: ", model.id)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textPanel.setFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        model.title = textPanel.title
        model.description = textPanel.desc
        
        if model == oldModel { return }
        if isNew,
           model.title == nil || model.title!.isEmpty,
           model.description == nil || model.description!.isEmpty
        {
            return
        }
        
        model.timestamp = Date()
        //debug
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
//        let date = dateFormatter.date(from: "20.06.2021 11:10")
//        if let date = date {
//            model.timestamp = date
//        }
        //
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let notificationManager = appDelegate.notificationManager {
            if model.scheduled != nil {
                notificationManager.scheduleNotification(note: model)
            }
            else {
                notificationManager.removeScheduledNotification(listId: [model.id])
            }
        }
        
        isNew ? database.write(model) : database.update(model)
        informParentWhenDone?()
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        backView = UIView(frame: view.bounds)
        backView.backgroundColor =  NoteColors.getBlurColor(name: model.color )
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        controlPanel = NoteEditControlPanel()
        controlPanel.configure(model: model)
        controlPanel.delegate = self
        
        textPanel = NoteEditTextPanel()
        textPanel.configure(model: model)
        textPanel.delegate = self
        
        blurEffectView.contentView.addSubview(controlPanel)
        blurEffectView.contentView.addSubview(textPanel)
        view.addSubview(backView)
        view.addSubview(blurEffectView)
        
        controlPanel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        
        textPanel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(controlPanel.snp.bottom)
        }
    }
    
    //MARK: - Action
    func didCloseTouched() {
        self.dismiss(animated: true)
    }
    
    func didButtonPinTouched() {
        model.pinned = !model.pinned
    }
    
    func didButtonScheduleTouched() {
        if model.scheduled != nil && model.scheduled! > .now {
            let alert = UIAlertController(title: "Unscheduling", message: "Note will be unscheduled. Are you sure?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Unschedule", style: .destructive, handler: { [weak self] _ in
                self?.didScheduled(date: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let datePickerViewController = DatePickerViewController()
        datePickerViewController.doOnDisappear = didScheduled(date:)
        present(datePickerViewController, animated: true)
    }
    
    func didScheduled(date: Date?) {
        model.scheduled = date
        controlPanel.setScheduledMark(scheduled: date != nil)
    }

    func didColorMenuItemPicked( color: NoteColors.Names ) {
        model.color = color.rawValue
        backView.backgroundColor = NoteColors.getBlurColor(ename: color)
    }
    
    func didCategoryMenuItemPicked( category: NoteCategory ) {
        model.category = category.rawValue
    }
    
    //MARK: - Request data
    func getNoteId() -> Int {
        return model.id
    }
}
