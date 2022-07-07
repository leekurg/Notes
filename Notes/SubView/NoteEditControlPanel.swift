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
    private var buttonSchedule: UIButton!
    private var buttonClose: UIButton!
    
    private var pinned = false
    private var scheduled = false
    
    func configure(model: NoteDataModel) {
        self.backgroundColor = Asset.Main.transGray.color
        
        buttonColor = {
            let button = UIButton()
            button.layer.borderWidth = 1
            button.layer.borderColor = Asset.Main.transWhite.color.cgColor
            button.layer.cornerRadius = 15
            
            button.menu = createColorMenu()
            button.showsMenuAsPrimaryAction = true
            
            return button
        }()
        
        
        buttonPin = {
            let button = UIButton()
            button.layer.borderWidth = 1
            button.layer.borderColor = Asset.Main.transWhite.color.cgColor
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(didButtonPinTouched), for: .touchUpInside)
            return button
        }()
        setPinnedMark(pinned: false)
        
        buttonCategory = {
            var config  = UIButton.Configuration.filled()
            
            config.image = createCFIcon(systemName: "chevron.down", color: Asset.Main.transWhite.color, pointSize: 17, weigth: .thin, scale: .small)
            config.imagePlacement = .trailing
            config.imagePadding = 5
            config.background.backgroundColor = .clear
            
            let button = UIButton(configuration: config)
            button.layer.borderWidth = 1
            button.layer.borderColor = Asset.Main.transWhite.color.cgColor
            button.layer.cornerRadius = 15
            
            button.menu = createCategoryMenu()
            button.showsMenuAsPrimaryAction = true
            
            return button
        }()
        
        buttonSchedule  = {
            let button = UIButton()
            button.layer.borderWidth = 1
            button.layer.borderColor = Asset.Main.transWhite.color.cgColor
            button.layer.cornerRadius = 15
            button.addTarget(self, action: #selector(didButtonScheduleTouched), for: .touchUpInside)
            return button
        }()
        setScheduledMark(scheduled: model.scheduled != nil && model.scheduled! > .now)
        
        buttonClose = {
            let button = UIButton()
            button.setImage( createCFIcon(systemName: "xmark.circle", color: Asset.Main.transWhite.color, pointSize: 30, weigth: .thin, scale: .large), for: .normal)
            button.layer.cornerRadius = 15

            button.addTarget(self, action: #selector(didCloseTouched), for: .touchUpInside)

            return button
        }()
        
        self.addSubview(buttonColor)
        self.addSubview(buttonPin)
        self.addSubview(buttonCategory)
        self.addSubview(buttonSchedule)
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
        
        buttonSchedule.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(buttonClose.snp.leading).inset(-15)
            make.width.height.equalTo(30)
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
                               image: createCFIcon(systemName: "circle.fill", color: colorMark)) { [weak self] _ in
                self?.didColorMenuItemPicked(color: colorName)
            }
            
            return act
        }
        
        var actions: [UIAction] = []
        for color in NoteColors.Names.allCases {
            actions.append( createAction(title: color.tr(), colorName: color))
        }
            
        return UIMenu(title: L10n.menuColorsTitle, options: .displayInline, children: actions)
    }
    
    private func createCategoryMenu() -> UIMenu {
            
        func createAction( title: String, categoryName: NoteCategory) -> UIAction
        {
            let act = UIAction(title: title,
                               image: createCFIcon(systemName: "folder.fill", color: Asset.Main.categoryIcon.color)) { [weak self] _ in
                self?.didCategoryMenuItemPicked(category: categoryName)
            }
            return act
        }
        
        var actions: [UIAction] = []
        for category in NoteCategory.allCases {
            if category == .pinned { continue }
            actions.append( createAction(title: category.tr().capitalized, categoryName: category))
        }
            
        return UIMenu(title: L10n.menuCategoriesTitle, options: .displayInline, children: actions)
    }
    
    //MARK: - Action
    private func didColorMenuItemPicked( color: NoteColors.Names ) {
        delegate?.didColorMenuItemPicked(color: color)
        setColorMark(color: color)
    }
    
    private func didCategoryMenuItemPicked( category: NoteCategory ) {
        delegate?.didCategoryMenuItemPicked(category: category)
        setCategory(category: category)
    }
    
    private func setColorMark( color: NoteColors.Names ) {
        let colorMark = NoteColors.getMarkColor(ename: color)
        buttonColor.setImage(createCFIcon(systemName: "circle.fill", color: colorMark), for: .normal)
    }
    
    private func setPinnedMark(pinned: Bool) {
        self.pinned = pinned
        UIView.transition(with: buttonPin, duration: 0.5, options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.buttonPin.setImage(createCFIcon(systemName: pinned ? "pin.fill" : "pin", color: Asset.Main.transWhiteAcsent.color), for: .normal) },
                          completion: nil
        )
    }
    
    func setScheduledMark(scheduled: Bool) {
        self.scheduled = scheduled
        UIView.transition(with: buttonSchedule, duration: 0.5, options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.buttonSchedule.setImage(createCFIcon(systemName: scheduled ? "bell.fill" : "bell", color: Asset.Main.transWhiteAcsent.color), for: .normal) },
                          completion: nil
        )
    }
    
    private func setCategory(category: NoteCategory?) {
        buttonCategory.setTitle(category?.tr().uppercased(), for: .normal)
    }

    @objc private func didCloseTouched() {
        delegate?.didCloseTouched()
    }
    
    @objc private func didButtonPinTouched() {
        delegate?.didButtonPinTouched()
        setPinnedMark(pinned: !pinned)
    }
    
    @objc private func didButtonScheduleTouched() {
        delegate?.didButtonScheduleTouched()
    }
    
}
