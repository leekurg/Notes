//
//  NoContentView.swift
//  Notes
//
//  Created by smartway on 21.06.2022.
//

import UIKit

class NoContentView: UIView {
    
    func configure() {
        let labelTitle = UILabel()
        labelTitle.text = "No content"
        labelTitle.textColor = .lightGray
        labelTitle.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        let labelDesc = UILabel()
        labelDesc.text = "No content is matching your request"
        labelDesc.textColor = .lightGray
        
        addSubview(labelTitle)
        addSubview(labelDesc)
        
        labelTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        
        labelDesc.snp.makeConstraints { make in
            make.top.equalTo(labelTitle.snp.bottom)
            make.centerX.equalTo(labelTitle)
        }
    }
}
