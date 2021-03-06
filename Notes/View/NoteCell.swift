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
    let pinMark: UIImageView!
    let selectMark: UIImageView!
    let scheduleLabel: ScheduleLabel!
    
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
        
        pinMark = {
            let view = UIImageView()
            view.image = createCFIcon(systemName: "pin.fill", color: Asset.Main.transGray.color, pointSize: 20, weigth: .thin, scale: .small)
            view.alpha = 0
            return view
        }()
        
        scheduleLabel = ScheduleLabel()
        scheduleLabel.configure()
        
        
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
        contentView.addSubview(pinMark)
        contentView.addSubview(scheduleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(7)
            make.height.equalTo(35)
        }

        descLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(15)
        }
        
        selectMark.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview().inset(7)
        }
        
        pinMark.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(5)
        }
        
        scheduleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = ""
        self.descLabel.text = ""
        scheduleLabel.setScheduledMark(date: nil)
        self.backgroundColor = NoteColors.getColor(ename: .base)
        self.pinMark.alpha = 0
        self.setSelected(selected: false)
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
    
    func setScheduledMark(date: Date?) {
        scheduleLabel.setScheduledMark(date: date)
    }
}
