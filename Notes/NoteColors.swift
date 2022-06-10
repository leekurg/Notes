//
//  NoteColors.swift
//  Notes
//
//  Created by Ильяяя on 10.06.2022.
//

import UIKit

struct NoteColors {
    enum Names: String {
        case base = "base"
        case blue = "blue"
        case pink = "pink"
        case cream = "cream"
        case green = "green"
        case purple = "purple"
    }
    
    static let colors: Dictionary<String, UIColor> = [
        Names.base.rawValue     : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1),
        Names.blue.rawValue     : UIColor(red: 224/255, green: 236/255, blue: 255/255, alpha: 1),
        Names.pink.rawValue     : UIColor(red: 255/255, green: 200/255, blue: 200/255, alpha: 1),
        Names.cream.rawValue    : UIColor(red: 240/255, green: 227/255, blue: 209/255, alpha: 1),
        Names.green.rawValue    : UIColor(red: 233/255, green: 245/255, blue: 223/255, alpha: 1),
        Names.purple.rawValue   : UIColor(red: 240/255, green: 225/255, blue: 245/255, alpha: 1)
    ]
    
    static func getColorForName ( name: String? ) -> Names {
        guard let name = name else { return .base }
        
        return Names(rawValue: name) ?? .base
    }
    
    static func getColor( name: String? ) -> UIColor {
        guard let name = name else {
            return colors[Names.base.rawValue]!
        }

        return colors[name] != nil ? colors[name]! : colors[Names.base.rawValue]!
    }
    static func getColor( ename: Names ) -> UIColor {
        return colors[ename.rawValue] != nil ? colors[ename.rawValue]! : colors[Names.base.rawValue]!
    }
    
    static func getMarkColor( ename: Names ) -> UIColor {
        switch(ename) {
        case .blue:     return UIColor.blue
        case .pink:     return UIColor(red: 255/255, green: 150/255, blue: 150/255, alpha: 1)
        case .cream:    return UIColor(red: 230/255, green: 213/255, blue: 161/255, alpha: 1)
        case .green:    return UIColor.green
        case .purple:   return UIColor.purple
        default:        return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        }
    }
    
    static func getBlurColor( name: String? ) -> UIColor {
        return getBlurColor(ename: getColorForName(name: name))
    }
    static func getBlurColor( ename: Names ) -> UIColor {
        switch(ename) {
        case .blue:     return UIColor(red: 0, green: 0, blue: 1, alpha: 0.05)
        case .pink:     return UIColor(red: 1, green: 0, blue: 0, alpha: 0.05)
        case .cream:    return UIColor(red: 1, green: 150/255, blue: 0, alpha: 0.05)
        case .green:    return UIColor(red: 0, green: 0.5, blue: 0, alpha: 0.05)
        case .purple:   return UIColor(red: 1, green: 0, blue: 1, alpha: 0.05)
        default:    return UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
}
