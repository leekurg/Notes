//
//  NoteEditControlPanel.swift
//  Notes
//
//  Created by smartway on 20.06.2022.
//

import UIKit

final class NoteEditControlPanel: UIView {
    var delegate: NoteEditViewController?
    
    private var buttonColor: UIButton!
    private var buttonPin: UIButton!
    private var buttonCategory: UIButton!
    private var buttonClose: UIButton!
    
    private var pinned = false
    
    func configure(model: NoteDataModel) {
        self.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.4)
        
        buttonColor = {
            let button = UIButton()
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
            button.layer.cornerRadius = 15
            
            button.menu = createColorMenu()
            button.showsMenuAsPrimaryAction = true
            
            return button
        }()
        
        
        buttonPin = {
            let button = UIButton()
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(didButtonPinTouched), for: .touchUpInside)
            return button
        }()
        setPinnedMark(pinned: false)
        
        buttonCategory = {
            var config  = UIButton.Configuration.filled()
            
            let smallImgConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .thin, scale: .small)
            config.image = UIImage(systemName: "chevron.down" )?.withConfiguration(smallImgConfig).withTintColor( UIColor(white: 1, alpha: 0.7), renderingMode: .alwaysOriginal)
            config.imagePlacement = .trailing
            config.imagePadding = 5
            config.background.backgroundColor = .clear
            
            let button = UIButton(configuration: config)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
            button.layer.cornerRadius = 15
            
            button.menu = createCategoryMenu()
            button.showsMenuAsPrimaryAction = true
            
            return button
        }()
        
        buttonClose = {
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
        
        self.addSubview(buttonColor)
        self.addSubview(buttonPin)
        self.addSubview(buttonCategory)
        self.addSubview(buttonClose)
        
        buttonColor.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
            make.width.height.equalTo(30)
        }
        
        buttonPin.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(buttonColor.snp.trailing).offset(10)
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
        
        setCategory(category: model.category)
        setColorMark(color: NoteColors.getColorForName(name: model.color))
        setPinnedMark(pinned: model.pinned)
    }
    
    //MARK: - Create menus
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
    
    //MARK: - Action
    private func didColorMenuItemPicked( color: NoteColors.Names ) {
        delegate?.didColorMenuItemPicked(color: color)
        setColorMark(color: color)
    }
    
    private func didCategoryMenuItemPicked( category: NoteCategory ) {
        delegate?.didCategoryMenuItemPicked(category: category)
        setCategory(category: category.rawValue)
    }
    
    private func setColorMark( color: NoteColors.Names ) {
        let colorMark = NoteColors.getMarkColor(ename: color)
        buttonColor.setImage(UIImage(systemName: "circle.fill" )?.withTintColor(colorMark, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    private func setPinnedMark(pinned: Bool) {
        self.pinned = pinned
        UIView.transition(with: buttonPin, duration: 0.5, options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.buttonPin.setImage(UIImage(systemName: pinned ? "pin.fill" : "pin" )?.withTintColor(UIColor(white: 1, alpha: 0.7), renderingMode: .alwaysOriginal), for: .normal) },
                          completion: nil
        )
    }
    
    private func setCategory(category: String?) {
        buttonCategory.setTitle(category?.uppercased(), for: .normal)
    }

    @objc private func didCloseTouched() {
        delegate?.didCloseTouched()
    }
    
    @objc private func didButtonPinTouched() {
        delegate?.didButtonPinTouched()
        setPinnedMark(pinned: !pinned)
    }
    
}
