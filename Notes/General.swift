//
//  General.swift
//  Notes
//
//  Created by Илья Аникин on 07.07.2022.
//

import Foundation
import UIKit

func createCFIcon(systemName: String, color: UIColor, pointSize: CGFloat = 18, weigth: UIImage.SymbolWeight = .regular, scale: UIImage.SymbolScale = .default) -> UIImage? {
    
    let image = UIImage(systemName: systemName )?.withTintColor(color, renderingMode: .alwaysOriginal).withConfiguration(UIImage.SymbolConfiguration(pointSize: pointSize, weight: weigth, scale: scale))
    return image
}
