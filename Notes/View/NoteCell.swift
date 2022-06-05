//
//  NoteCell.swift
//  Notes
//
//  Created by Ильяяя on 05.06.2022.
//

import UIKit
import SnapKit

class NoteCell: UICollectionViewCell {
    static let reuseID = "NoteCell"
    
    let titleLabel: UILabel!
    let descLabel: UITextView!
    
    override init(frame: CGRect) {
                
        titleLabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            return label
        }()
        
        descLabel = {
            let view = UITextView()
            view.backgroundColor = UIColor.clear
            view.layer.cornerRadius = 20
            view.font = UIFont.systemFont(ofSize: 17, weight: .thin)
            view.isUserInteractionEnabled = false
            return view
        }()
        
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        layer.cornerRadius = 20
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 7.0
        layer.shadowOpacity = 0.4
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(7)
            make.height.equalToSuperview().multipliedBy(0.2)
        }

        descLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(5)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBackgroundColor( color: CGColor? ) {
        guard let color = color else { return }
        
        backgroundColor = UIColor(cgColor: color)
    }
    
    func setHighlighted( highlighted: Bool = true ) {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            if highlighted {
                self?.layer.shadowOpacity = 0.6
                self?.layer.shadowRadius = 12.0
            }
            else {
                self?.layer.shadowOpacity = 0.4
                self?.layer.shadowRadius = 7.0
            }
        }
    }
    
    func setSelected( selected: Bool = true ) {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            if selected {
                self?.layer.borderWidth = 1
                self?.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).cgColor
            }
            else {
                self?.layer.borderWidth = 0
                self?.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
            }
        }
    }
}
