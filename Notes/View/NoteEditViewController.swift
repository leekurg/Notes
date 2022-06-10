
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
    private var buttonColor: UIButton!
    private var backView: UIView!
    
    private var model: NoteDataModel!
    private var isNew = false
    private var isEdited = false
    
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard isEdited else { return }
        
        if isNew && titleTextView.text.isEmpty && descTextView.text.isEmpty { return }
        
        model.timestamp = Date()
        model.title = titleTextView.text
        model.description = descTextView.text
        
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
        
        buttonColor = {
            let button = UIButton()
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
            button.layer.cornerRadius = 15
            
            button.menu = createColorMenu()
            button.showsMenuAsPrimaryAction = true
            
            return button
        }()
        setButtonColorMark(color: NoteColors.getColorForName(name: model.color))
        
        let buttonClose: UIButton = {
            let button = UIButton()
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .thin, scale: .large)
            button.setImage(
                UIImage(systemName: "xmark.circle" )?.withConfiguration(largeConfig)
                    .withTintColor( UIColor(white: 1, alpha: 0.5), renderingMode: .alwaysOriginal)
                    , for: .normal)
            button.layer.cornerRadius = 15
            
            button.addTarget(self, action: #selector(didCloseTouched), for: .touchUpInside)
            
            return button
        }()
        
        titleTextView = {
            let view = UITextView()
            view.delegate = self
            view.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
            view.textContainerInset = UIEdgeInsets(top: 20, left: 45, bottom: 10, right: 45)
            return view
        }()
        
        descTextView = {
            let view = UITextView()
            view.delegate = self
            view.font = UIFont.systemFont(ofSize: 20, weight: .thin)
            view.backgroundColor = .clear
            view.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            return view
        }()
        
        blurEffectView.contentView.addSubview(buttonColor)
        blurEffectView.contentView.addSubview(buttonClose)
        blurEffectView.contentView.addSubview(titleTextView)
        blurEffectView.contentView.addSubview(descTextView)
        view.addSubview(backView)
        view.addSubview(blurEffectView)
    
        buttonColor.snp.makeConstraints { make in
            make.centerY.equalTo(titleTextView)
            make.left.equalToSuperview().inset(15)
            make.width.height.equalTo(30)
        }
        
        buttonClose.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(5)
            make.width.height.equalTo(30)
        }
        
        titleTextView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }

        descTextView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(titleTextView.snp.bottom)
        }
        
        blurEffectView.contentView.bringSubviewToFront(buttonColor)
        blurEffectView.contentView.bringSubviewToFront(buttonClose)
        
        //fill
        if let model = model {
            titleTextView.text = model.title
            descTextView.text = model.description
        }
    }
    
    private func createColorMenu() -> UIMenu {
            
        func createAction( title: String, colorName: NoteColors.Names) -> UIAction
        {
            let colorMark = NoteColors.getMarkColor(ename: colorName)
            
            let act = UIAction(title: title,
                               image: UIImage(systemName: "circle.fill" )?.withTintColor(colorMark, renderingMode: .alwaysOriginal)) { [weak self] _ in
                self?.didColorMenuItemPicked(color: colorName)
            }
            
            return act
        }
        
        let actions: [UIAction] = [
            createAction(title: "Default", colorName: .base),
            createAction(title: "Blue", colorName: .blue),
            createAction(title: "Pink", colorName: .pink),
            createAction(title: "Cream", colorName: .cream),
            createAction(title: "Green", colorName: .green),
            createAction(title: "Purple", colorName: .purple)
        ]
            
        return UIMenu(title: "Colors", options: .displayInline, children: actions)
    }
    
    //MARK: Action
    @objc private func didCloseTouched() {
        self.dismiss(animated: true)
    }
    
    private func didColorMenuItemPicked( color: NoteColors.Names ) {
        model.color = color.rawValue

        backView.backgroundColor = NoteColors.getBlurColor(ename: color)
        setButtonColorMark(color: color)
        
        isEdited = true
    }
    
    private func setButtonColorMark( color: NoteColors.Names ) {
        let colorMark = NoteColors.getMarkColor(ename: color)
        buttonColor.setImage(UIImage(systemName: "circle.fill" )?.withTintColor(colorMark, renderingMode: .alwaysOriginal), for: .normal)
    }
}

//MARK: - TextView Delegate
extension NoteEditViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        self.isEdited = true
    }
}
