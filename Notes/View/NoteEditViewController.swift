
//  NoteEditViewController.swift
//  Notes
//
//  Created by Ильяяя on 06.06.2022.
//

import UIKit
import SnapKit

class NoteEditViewController: UIViewController {
    
    private var controlPanel: NoteEditControlPanel!
    private var titleTextView: UITextView!
    private var descTextView: UITextView!
    private var titlePlaceholder: UILabel?
    private var descPlaceholder: UILabel?
    
    private var buttonCategory: UIButton!
    private var buttonColor: UIButton!
    private var buttonPin: UIButton!
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
        let _ = isNew ? titleTextView.becomeFirstResponder() : descTextView.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if model == oldModel { return }
        if isNew,
           model.title == nil || model.title!.isEmpty,
           model.description == nil || model.description!.isEmpty
        {
            return
        }
        
        model.timestamp = Date()
        
        isNew ? database.write(model) : database.update(model)

        if let inform = informParentWhenDone {
            inform()
        }
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
        controlPanel.delegate = self
        controlPanel.configure(model: model)
        
        
        titleTextView = {
            let view = UITextView()
            view.delegate = self
            view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            view.backgroundColor = .clear
            view.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 45)
            view.text = model?.title ?? nil
            view.isScrollEnabled = false;
            view.textContainer.maximumNumberOfLines = 1;
            

            titlePlaceholder = {
                let label = UILabel()
                label.text = "Enter title..."
                label.font = .italicSystemFont(ofSize: (view.font?.pointSize)!)
                view.addSubview(label)
                label.textColor = .gray
                label.isHidden = !view.text.isEmpty
                
                label.snp.makeConstraints { make in
                    make.leading.equalToSuperview().inset( view.textContainerInset.left + 5 )
                    make.centerY.equalToSuperview()
                }
                return label
            }()
            
            return view
        }()
        
        descTextView = {
            let view = UITextView()
            view.delegate = self
            view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            view.backgroundColor = .clear
            view.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            view.text = model?.description ?? nil
            
            descPlaceholder = {
                let label = UILabel()
                label.text = "Enter text..."
                label.font = .italicSystemFont(ofSize: (view.font?.pointSize)!)
                view.addSubview(label)
                label.textColor = .gray
                label.isHidden = !view.text.isEmpty
                
                label.snp.makeConstraints { make in
                    make.top.equalToSuperview().inset( view.textContainerInset.top )
                    make.leading.equalToSuperview().inset( view.textContainerInset.left + 5 )

                }
                return label
            }()
            
            let _: UIView = {
                let separator = UIView()
                separator.layer.borderWidth = 1
                separator.layer.borderColor = UIColor(white: 0.3, alpha: 0.2).cgColor
                
                view.addSubview(separator)
                
                separator.snp.makeConstraints { make in
                    make.bottom.equalTo(view.snp.bottom).inset(-1)
                    make.centerX.equalToSuperview()
                    make.height.equalTo(1)
                    make.width.equalToSuperview().multipliedBy(0.9)
                }

                return separator
            }()
            
            return view
        }()
        
        blurEffectView.contentView.addSubview(controlPanel)
        blurEffectView.contentView.addSubview(titleTextView)
        blurEffectView.contentView.addSubview(descTextView)
        view.addSubview(backView)
        view.addSubview(blurEffectView)
        
        controlPanel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        
        titleTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(controlPanel.snp.bottom)
            make.height.equalTo(70)
        }

        descTextView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(titleTextView.snp.bottom)
        }
    }
    
    //MARK: Action
    func didCloseTouched() {
        self.dismiss(animated: true)
    }
    
    func didButtonPinTouched() {
        model.pinned = !model.pinned
    }

    func didColorMenuItemPicked( color: NoteColors.Names ) {
        model.color = color.rawValue
        backView.backgroundColor = NoteColors.getBlurColor(ename: color)
    }
    
    func didCategoryMenuItemPicked( category: NoteCategory ) {
        model.category = category.rawValue
    }
}

//MARK: - TextView Delegate
extension NoteEditViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        switch(textView) {
        case titleTextView: model.title = titleTextView.text
        case descTextView:  model.description = descTextView.text
        default: return
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch(textView) {
        case titleTextView: titlePlaceholder?.isHidden = !textView.text.isEmpty
        case descTextView: descPlaceholder?.isHidden = !textView.text.isEmpty
        default: return
        }
    }
}
