//
//  NoteEditTextPanel.swift
//  Notes
//
//  Created by smartway on 20.06.2022.
//

import UIKit

final class NoteEditTextPanel: UIView {
    var delegate: NoteEditViewController?
    
    private var titleTextView: UITextView!
    private var descTextView: UITextView!
    private var titlePlaceholder: UILabel?
    private var descPlaceholder: UILabel?
    
    var title: String?
    var desc: String?
    
    func configure(model: NoteDataModel) {
        titleTextView = {
            let view = UITextView()
            view.delegate = self
            view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            view.backgroundColor = .clear
            view.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 45)
            view.text = model.title ?? nil
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
            view.text = model.description ?? nil
            
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
        
        self.addSubview(titleTextView)
        self.addSubview(descTextView)
        
        titleTextView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }

        descTextView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(titleTextView.snp.bottom)
        }
        
        title = model.title ?? nil
        desc = model.description ?? nil
    }
    
    func setFirstResponder() {
        if (title == nil || title!.isEmpty) &&
            (desc == nil || desc!.isEmpty) {
            titleTextView.becomeFirstResponder()
        }
        else {
            descTextView.becomeFirstResponder()
        }
    }
}

//MARK: - TextView Delegate
extension NoteEditTextPanel: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        switch(textView) {
        case titleTextView: self.title = titleTextView.text
        case descTextView:  self.desc = descTextView.text
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

