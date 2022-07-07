//
//  NoteCategory.swift
//  Notes
//
//  Created by Ильяяя on 13.06.2022.
//

//import Foundation

enum NoteCategory: String, CaseIterable {
case pinned     = "pinned"
case other      = "other"
case pesonal    = "personal"
case work       = "work"
    
    func tr() -> String{
        switch(self) {
        case .pinned:   return L10n.noteCategoryPinned
        case .other:    return L10n.noteCategoryOther
        case .pesonal:  return L10n.noteCategoryPersonal
        case .work:     return L10n.noteCategoryWork
        }
    }
}
