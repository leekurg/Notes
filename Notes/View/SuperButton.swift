//
//  FlyButton.swift
//  Notes
//
//  Created by Ильяяя on 09.06.2022.
//

import UIKit

extension UIButton {
    static func createSuperButton( cornerRadius: CGFloat = 0 ) -> UIButton {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = cornerRadius
        button.setImage(createCFIcon(systemName: "plus", color: Asset.Main.superButtonIcon.color, pointSize: 20, weigth: .bold, scale: .large), for: .normal)
        button.layer.shadowOffset = CGSize(width: 15, height: 15)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 10
        button.layer.shadowColor = Asset.Main.shadow.color.cgColor
        
        button.addBlurEffect(style: .light, cornerRadius: cornerRadius, padding: 0)
        button.backgroundColor = Asset.Main.superButtonNew.color
        return button
    }

    func addBlurEffect(style: UIBlurEffect.Style = .regular, cornerRadius: CGFloat = 0, padding: CGFloat = 0) {
        backgroundColor = .clear
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blurView.isUserInteractionEnabled = false
        blurView.backgroundColor = .clear
        if cornerRadius > 0 {
            blurView.layer.cornerRadius = cornerRadius
            blurView.layer.masksToBounds = true
        }
        self.insertSubview(blurView, at: 0)

        blurView.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -padding).isActive = true
        self.topAnchor.constraint(equalTo: blurView.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -padding).isActive = true

        if let imageView = self.imageView {
            imageView.backgroundColor = .clear
            self.bringSubviewToFront(imageView)
        }
    }
    
}
