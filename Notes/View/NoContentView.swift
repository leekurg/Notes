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
        labelTitle.text = L10n.noContentTitle
        labelTitle.textColor = Asset.Main.transGray.color
        labelTitle.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        
        let labelDesc = UILabel()
        labelDesc.text = L10n.noContentText
        labelDesc.textColor = Asset.Main.transGray.color
        
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
