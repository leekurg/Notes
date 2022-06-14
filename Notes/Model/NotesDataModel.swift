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

struct NoteDataModel {
    var id: Int
    var timestamp: Date
    var title: String?
    var description: String?
    var color: String?
    var category: String?
}

extension NoteDataModel {
    init( object: NoteDataObject ) {
        id = object.id
        timestamp = object.timestamp
        title = object.title
        description = object.desc
        color = object.color
        category = object.category
    }
    
    init( id: Int ) {
        self.id = id
        timestamp = Date()
        color = NoteColors.Names.base.rawValue
        category = NoteCategory.other.rawValue
    }
}
