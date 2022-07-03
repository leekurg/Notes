//
//  ScheduleLabel.swift
//  Notes
//
//  Created by Илья Аникин on 03.07.2022.
//

import Foundation
import UIKit

class ScheduleLabel: UIView {
    private var scheduleMark: UIImageView!
    private var dateLabel: UILabel!
    
    var text: String? {
        get {
            return dateLabel.text
        }
        set {
            dateLabel.text = newValue
            if newValue == nil || newValue!.isEmpty {
                scheduleMark.alpha = 0
            }
            else {
                scheduleMark.alpha = 1
            }
        }
    }
    
    func configure() {
        scheduleMark = {
            let view = UIImageView()
            view.image = UIImage(systemName: "bell.fill")?.withTintColor( UIColor(white: 0, alpha: 0.3), renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: 12, weight: .thin, scale: .small))
            view.alpha = 0
            return view
        }()
        
        dateLabel = {
            let label = UILabel()
            label.textColor = UIColor(white: 0, alpha: 0.7)
            label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
            label.textAlignment = .center
            return label
        }()
        
        addSubview(scheduleMark)
        addSubview(dateLabel)
        
        scheduleMark.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(scheduleMark.snp.trailing).inset(-5)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
}
