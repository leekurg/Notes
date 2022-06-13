
//  NoteEditViewController.swift
//  Notes
//
//  Created by Ильяяя on 06.06.2022.
//

import UIKit
import SnapKit

class NoteEditViewController: UIViewController {
    
    private var controlPanel: UIView!
    private var titleTextView: UITextView!
    private var descTextView: UITextView!
    private var titlePlaceholder: UILabel?
    private var descPlaceholder: UILabel?
    
    private var buttonCategory: UIButton!
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isNew {
            let _ = titleTextView.becomeFirstResponder()
        }
        else {
            let _ = descTextView.becomeFirstResponder()
        }
        
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
        
        controlPanel = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.4)
            
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
            
            buttonCategory = {
                var config  = UIButton.Configuration.filled()
                
                let smallImgConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .thin, scale: .small)
                config.image = UIImage(systemName: "chevron.down" )?.withConfiguration(smallImgConfig).withTintColor( UIColor(white: 1, alpha: 0.7), renderingMode: .alwaysOriginal)
                config.imagePlacement = .trailing
                config.imagePadding = 5
                config.background.backgroundColor = .clear
                
                let button = UIButton(configuration: config)
                button.setTitle(model.category?.uppercased(), for: .normal)
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
                button.layer.cornerRadius = 15
                
                button.menu = createCategoryMenu()
                button.showsMenuAsPrimaryAction = true
                
                return button
            }()
            
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
            
            view.addSubview(buttonColor)
            view.addSubview(buttonCategory)
            view.addSubview(buttonClose)
            
            buttonColor.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().inset(15)
                make.width.height.equalTo(30)
            }
            
            buttonCategory.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(150)
                make.height.equalTo(30)
            }
            
            buttonClose.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(15)
                make.width.height.equalTo(30)
            }
            
            return view
        }()
        
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
        
        var actions: [UIAction] = []
        for color in NoteColors.Names.allCases {
            actions.append( createAction(title: color.rawValue.capitalized, colorName: color))
        }
            
        return UIMenu(title: "Colors", options: .displayInline, children: actions)
    }
    
    private func createCategoryMenu() -> UIMenu {
            
        func createAction( title: String, categoryName: NoteCategory) -> UIAction
        {
            let act = UIAction(title: title,
                               image: UIImage(systemName: "folder.fill" )?.withTintColor(.orange, renderingMode: .alwaysOriginal)) { [weak self] _ in
                self?.didCategoryMenuItemPicked(category: categoryName)
            }
            
            return act
        }
        
        var actions: [UIAction] = []
        for category in NoteCategory.allCases {
            if category == .pinned { continue }
            actions.append( createAction(title: category.rawValue.capitalized, categoryName: category))
        }
            
        return UIMenu(title: "Categories", options: .displayInline, children: actions)
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
    
    private func didCategoryMenuItemPicked( category: NoteCategory ) {
        model.category = category.rawValue
        
        buttonCategory.setTitle(category.rawValue.uppercased(), for: .normal)
        
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
    
    func textViewDidChange(_ textView: UITextView) {
        switch(textView) {
        case titleTextView: titlePlaceholder?.isHidden = !textView.text.isEmpty
        case descTextView: descPlaceholder?.isHidden = !textView.text.isEmpty
        default: return
        }
    }
}
