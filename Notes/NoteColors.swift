//
//  NoteColors.swift
//  Notes
//
//  Created by Ильяяя on 10.06.2022.
//

import UIKit

struct NoteColors {
    enum Names: String, CaseIterable {
        case base   = "default"
        case blue   = "blue"
        case pink   = "pink"
        case cream  = "cream"
        case green  = "green"
        case purple = "purple"
    
        func tr() -> String {
            switch(self) {
            case .base:     return L10n.colorNameBase
            case .blue:     return L10n.colorNameBlue
            case .pink:     return L10n.colorNamePink
            case .cream:    return L10n.colorNameCream
            case .green:    return L10n.colorNameGreen
            case .purple:   return L10n.colorNamePurple
            }
        }
    }
    
    
    static let colors: Dictionary<String, UIColor> = [
        Names.base.rawValue     : Asset.NoteBackground.base.color,
        Names.blue.rawValue     : Asset.NoteBackground.blue.color,
        Names.pink.rawValue     : Asset.NoteBackground.pink.color,
        Names.cream.rawValue    : Asset.NoteBackground.cream.color,
        Names.green.rawValue    : Asset.NoteBackground.green.color,
        Names.purple.rawValue   : Asset.NoteBackground.purple.color
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
        case .blue:     return Asset.NoteMark.blue.color
        case .pink:     return Asset.NoteMark.pink.color
        case .cream:    return Asset.NoteMark.cream.color
        case .green:    return Asset.NoteMark.green.color
        case .purple:   return Asset.NoteMark.purple.color
        default:        return Asset.NoteMark.base.color
        }
    }
    
    static func getBlurColor( name: String? ) -> UIColor {
        return getBlurColor(ename: getColorForName(name: name))
    }
    static func getBlurColor( ename: Names ) -> UIColor {
        switch(ename) {
        case .blue:     return Asset.NoteBlur.blue.color
        case .pink:     return Asset.NoteBlur.pink.color
        case .cream:    return Asset.NoteBlur.cream.color
        case .green:    return Asset.NoteBlur.green.color
        case .purple:   return Asset.NoteBlur.purple.color
        default:        return Asset.NoteBlur.base.color
        }
    }
}
