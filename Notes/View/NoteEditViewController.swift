
//  NoteEditViewController.swift
//  Notes
//
//  Created by Ильяяя on 06.06.2022.
//

import UIKit
import SnapKit

class NoteEditViewController: UIViewController {
    
    private var titleTextView: UITextView!
    private var descTextView: UITextView!
    var model: NoteDataModel?
    private var isNew = false
    private var isEdited = false
    
    var informParentWhenDone: (() -> Void)?
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        if let model = model {
            print("Shown note id: ", model.id)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard isEdited else { return }
        
        if model == nil {
            isNew = true
        }
        
        if isNew {
            guard !titleTextView.text.isEmpty || !descTextView.text.isEmpty else { return }
            
            let id = database.lastId ?? 0
            model = NoteDataModel(id: id + 1)
        }
        
        
        model?.timestamp = Date()
        model?.title = titleTextView.text
        model?.description = descTextView.text
        
        database.write(model)
        
        if let inform = informParentWhenDone {
            inform()
        }
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        let backView = UIView(frame: view.bounds)
        backView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.0)
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        titleTextView = {
            let view = UITextView()
            view.delegate = self
            view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
            view.textContainerInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
            return view
        }()
        
        descTextView = {
            let view = UITextView()
            view.delegate = self
            view.font = UIFont.systemFont(ofSize: 20, weight: .thin)
            view.backgroundColor = .clear
            view.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            return view
        }()
        
        blurEffectView.contentView.addSubview(titleTextView)
        blurEffectView.contentView.addSubview(descTextView)
        view.addSubview(backView)
        view.addSubview(blurEffectView)
    
        
        titleTextView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }

        descTextView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(titleTextView.snp.bottom)
        }
        
        //fill
        if let model = model {
            titleTextView.text = model.title
            descTextView.text = model.description
        }
    }
}

//MARK: - TextView Delegate
extension NoteEditViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.isEdited = true
    }
}
