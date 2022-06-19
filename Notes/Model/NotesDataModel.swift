//
//  NotesDataModel.swift
//  Notes
//
//  Created by Ильяяя on 14.06.2022.
//

import Foundation


struct NotesDataModel {
    var sections: [SectionDataModel] = []
    
    var count: Int {
        get {
            return sections.count
        }
    }
    
    var allCount: Int {
        get {
            var c = 0
            for s in sections {
                c += s.notes.count
            }
            return c
        }
    }
    
    subscript(indexPath: IndexPath) -> NoteDataModel? {
        guard indexPath.section < sections.count,
                indexPath.item < sections[indexPath.section].notes.count
        else { return nil }
        
        return sections[indexPath.section].notes[indexPath.item]
    }
    
    mutating func append( note: NoteDataModel? ) {
        guard let note = note else {
            return
        }
        
        //pinned
        if note.pinned == true {
            if let index = getIndexForSectionName(section: NoteCategory.pinned.rawValue) {
                sections[index].notes.append(note)
            }
            else {
                sections.insert(SectionDataModel(name: NoteCategory.pinned.rawValue, notes: [note]), at: 0)
            }
            return
        }
        
        //other categories
        if let index = getIndexForSectionName(section: note.category) {
            sections[index].notes.append(note)
        }
        else {
            sections.append( SectionDataModel(name: note.category ?? NoteCategory.other.rawValue, notes: [note]))
        }
    }

    private func getIndexForSectionName( section: String? ) -> Int? {
        guard let section = section else {
            return nil
        }
        
        for index in sections.indices {
            if sections[index].name == section {
                return index
            }
        }
        return nil
    }
}

struct SectionDataModel {
    var name: String = ""
    var notes: [NoteDataModel] = []
}

struct NoteDataModel: Equatable {
    var id: Int
    var timestamp: Date
    var title: String?
    var description: String?
    var color: String?
    var category: String?
    var pinned: Bool
}

extension NoteDataModel {
    init( object: NoteDataObject ) {
        id = object.id
        timestamp = object.timestamp
        title = object.title
        description = object.desc
        color = object.color
        category = object.category
        pinned = object.pinned
    }
    
    init( id: Int ) {
        self.id = id
        timestamp = Date()
        color = NoteColors.Names.base.rawValue
        category = NoteCategory.other.rawValue
        pinned = false
    }
}
