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
    let selectMark: UIImageView!
    
    override init(frame: CGRect) {
                
        titleLabel = {
            let view = UITextView()
            view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            view.backgroundColor = .clear
            view.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            view.clipsToBounds = true
            view.isUserInteractionEnabled = false
            
            view.isScrollEnabled = false;
            view.textContainer.maximumNumberOfLines = 0;
            view.textContainer.lineBreakMode = .byTruncatingTail;
            return view
        }()
        
        descLabel = {
            let view = UITextView()
            view.backgroundColor = UIColor.clear
            view.layer.cornerRadius = 20
            view.font = UIFont.systemFont(ofSize: 17, weight: .thin)
            view.isUserInteractionEnabled = false
            
            view.isScrollEnabled = false;
            view.textContainer.maximumNumberOfLines = 0;
            view.textContainer.lineBreakMode = .byTruncatingTail;
            return view
        }()
        
        selectMark = {
            let view = UIImageView()
            view.image = UIImage(systemName: "checkmark.circle.fill")
            view.alpha = 0
            return view
        }()
        
        super.init(frame: frame)
        descLabel.textContainerInset = UIEdgeInsets(top: 35, left: 7, bottom: 5, right: 5)
        
        
        backgroundColor = NoteColors.getColor(ename: .base)
        layer.cornerRadius = 20
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 7.0
        layer.shadowOpacity = 0.4
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(selectMark)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(7)
            make.height.equalTo(35)
        }

        descLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(5)
        }
        
        selectMark.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(7)
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
    
    func searchText( text: String? ) {
        guard let text = text else {
            return
        }
    }
    
    
    func setBackgroundColor( color: CGColor? ) {
        guard let color = color else { return }
        
        backgroundColor = UIColor(cgColor: color)
    }
    
    func setTitleHidden() {
        titleLabel.isHidden = true
        descLabel.textContainerInset = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 5)
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
            self?.selectMark.alpha = selected ? 1 : 0
        }
    }
}

//public extension UITextView {
//    var visibleRange: NSRange? {
//        guard let start = closestPosition(to: contentOffset),
//                let end = characterRange(at: CGPoint(x: contentOffset.x + bounds.maxX,
//                                                   y: contentOffset.y + bounds.maxY))?.end
//        else { return nil }
//        return NSMakeRange(offset(from: beginningOfDocument, to: start), offset(from: start, to: end))
//    }
//}
