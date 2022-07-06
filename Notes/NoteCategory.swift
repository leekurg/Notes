//
//  NoteCategory.swift
//  Notes
//
//  Created by Ильяяя on 13.06.2022.
//

//import Foundation

enum NoteCategory: String, CaseIterable {
case pinned = "pinned"
case other = "other"
case pesonal = "personal"
case work = "work"
    
    func tr() -> String{
        switch(self) {
        case .pinned:   return "Pinned"
        case .other:    return "Other"
        case .pesonal:  return "Personal"
        case .work:     return "Work"
        }
    }
}
