//
//  DatePickerViewController.swift
//  Notes
//
//  Created by Илья Аникин on 02.07.2022.
//

import Foundation
import UIKit
import SnapKit

class DatePickerViewController: UIViewController {
    
    private var datePicker: UIDatePicker!
    private var buttonAccept: UIButton!
    private var buttonCancel: UIButton!
    
    var doOnDisappear: ((Date?) -> Void)?
    private var date: Date?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        doOnDisappear?(date)
    }
    
    //MARK: - Setup UI
    private func setupUI() {

        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        datePicker = {
            let picker = UIDatePicker()
            picker.preferredDatePickerStyle = .inline
            picker.minimumDate = .now.addingTimeInterval( TimeInterval(60) )
            return picker
        }()
        
        buttonAccept = {
            let button = UIButton(configuration: .filled())
            button.setTitle(L10n.scheduleButtonTitle, for: .normal)
            button.addTarget(self, action: #selector(didButtonAcceptTouched), for: .touchUpInside)
            return button
        }()
        
        buttonCancel = {
            let button = UIButton(configuration: .gray())
            button.setTitle(L10n.mainCancelAction, for: .normal)
            button.addTarget(self, action: #selector(close), for: .touchUpInside)
            return button
        }()
        
        blurEffectView.contentView.addSubview(datePicker)
        blurEffectView.contentView.addSubview(buttonAccept)
        blurEffectView.contentView.addSubview(buttonCancel)
        view.addSubview(blurEffectView)
        
        setupConstraints(forcePortrait: true)
    }
    
    private func setupConstraints(forcePortrait: Bool = false) {
        if forcePortrait || UIDevice.current.orientation.isPortrait {
            datePicker.snp.remakeConstraints { make in
                make.top.equalToSuperview().inset(20)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.9)
            }
            
            buttonCancel.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().inset(40)
                make.width.equalToSuperview().multipliedBy(0.8)
            }
            
            buttonAccept.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(buttonCancel.snp.top).offset(-10)
                make.width.equalToSuperview().multipliedBy(0.8)
            }
        }
        else {
            datePicker.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.9)
            }
            
            buttonCancel.snp.remakeConstraints { make in
                make.trailing.bottom.equalToSuperview().inset(30)
                make.width.equalTo(100)
            }
            
            buttonAccept.snp.remakeConstraints{ make in
                make.trailing.equalToSuperview().inset(30)
                make.bottom.equalTo(buttonCancel.snp.top).offset(-10)
                make.width.equalTo(100)
            }
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        setupConstraints()
    }
    
    @objc func didButtonAcceptTouched() {
        date = datePicker.date
        self.close()
    }

    @objc func close() {
        dismiss(animated: true)
    }
}
