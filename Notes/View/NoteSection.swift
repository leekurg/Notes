//
//  NoteSection.swift
//  Notes
//
//  Created by Ильяяя on 13.06.2022.
//

import UIKit

class NoteSection: UICollectionReusableView {
    static let reuseID = "NoteSection"
    let titleLabel: UILabel!
    
    override init(frame: CGRect) {
        titleLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = Asset.Main.lightGray.color
            return label
        }()
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        let _: UIView = {
            let separator = UIView()
            separator.layer.borderWidth = 1
            separator.layer.borderColor = Asset.Main.noteSectionSeparator.color.cgColor
            
            addSubview(separator)
            
            separator.snp.makeConstraints { make in
                make.centerY.equalTo(titleLabel)
                make.leading.equalTo(titleLabel.snp.trailing).inset(-10)
                make.trailing.equalToSuperview().inset(10)
                make.height.equalTo(1)
            }

            return separator
        }()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
    }
}
