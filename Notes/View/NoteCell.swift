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
    
    let titleLabel: UITextView!
    let descLabel: UITextView!
    
    override init(frame: CGRect) {
                
        titleLabel = {
            let view = UITextView()
            view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            view.backgroundColor = .clear
            view.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            view.clipsToBounds = true
            return view
        }()
        
        let separator: UIView = {
            let view = UIView()
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
            return view
        }()
        
        descLabel = {
            let view = UITextView()
            view.backgroundColor = UIColor.clear
            view.layer.cornerRadius = 20
            view.font = UIFont.systemFont(ofSize: 17, weight: .thin)
            view.isUserInteractionEnabled = false
            view.textContainerInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 5)
            return view
        }()
        
        super.init(frame: frame)
        
        backgroundColor = NoteColors.getColor(ename: .base)
        layer.cornerRadius = 20
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 7.0
        layer.shadowOpacity = 0.4
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(separator)
        contentView.addSubview(descLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(7)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().multipliedBy(0.9)
        }

        descLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(5)
            make.top.equalTo(titleLabel.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.descLabel.text = ""
        self.backgroundColor = NoteColors.getColor(ename: .base)
        self.setSelected(selected: false)
    }
    
    func setBackgroundColor( color: CGColor? ) {
        guard let color = color else { return }
        
        backgroundColor = UIColor(cgColor: color)
    }
    
    func setHighlighted( highlighted: Bool = true ) {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            self?.layer.shadowOpacity = highlighted ? 0.6 : 0.4
            self?.layer.shadowRadius = highlighted ? 12.0 : 7.0
        }
    }
    
    func setSelected( selected: Bool = true ) {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            self?.layer.borderWidth = selected ? 2 : 0
        }
    }
}
