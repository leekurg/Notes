//
//  Database.swift
//  Notes
//
//  Created by Ильяяя on 07.06.2022.
//

import RealmSwift

class Database {
    private let realm: Realm!
    var lastId: Int?
    
    init() {
        do {
            realm = try Realm()
        }
        catch {
            fatalError("Realm database is unable to start")
        }
    }
    
    
    func write(_ model: NoteDataModel?) {
        guard let model = model else {return}
        try! realm.write({
            
            let object = NoteDataObject()
            object.id = model.id
            object.timestamp = model.timestamp
            object.scheduled = model.scheduled
            object.title = model.title ?? ""
            object.desc = model.description ?? ""
            object.color = model.color ?? ""
            object.category = model.category ?? ""
            object.pinned = model.pinned
                
            realm.add(object)
        })
    }
    
    func update(_ model: NoteDataModel?) {
        guard let model = model else {return}
        
        if let object = realm.objects( NoteDataObject.self ).filter("id == %@", model.id).first {

            try! realm.write({
                object.timestamp = model.timestamp
                object.scheduled = model.scheduled
                object.title = model.title ?? ""
                object.desc = model.description ?? ""
                object.color = model.color ?? ""
                object.category = model.category ?? ""
                object.pinned = model.pinned
            })
        }
    }
    
    func updatePin(listId: [Int]) {
        let objects = realm.objects( NoteDataObject.self ).filter("id IN %@", listId)
        
        func bool( from n: Int? ) -> Bool? {
            guard let n = n else { return nil }
            if n > 0 { return true }
            return false
        }
        
        try! realm.write({
            for object in objects {
                let value = bool(from: object.value(forKey: "pinned") as? Int )
                if let pinned = value {
                    object.setValue( !pinned, forKey: "pinned")
                }
            }
        })
    }
    
    func updateUnschedule(listId: [Int]) {
        let objects = realm.objects( NoteDataObject.self ).filter("id IN %@", listId)

        try! realm.write({
            for object in objects {
                object.setValue( nil, forKey: "scheduled")
            }
        })
    }
    
    func read( query: String? = nil ) -> NotesDataModel {
        
        var data = realm.objects( NoteDataObject.self ).sorted(byKeyPath: "timestamp", ascending: false)
        lastId = data.max(ofProperty: "id") as Int?
        
        if let query = query {
            data = data.filter("desc contains[c] %@ OR title contains[c] %@", query, query)
        }
            
        var model = NotesDataModel()
        for item in data {
            model.append(note: NoteDataModel(object: item))
        }
        
        return model
    }
    
    func remove( listId: [Int]) -> Bool {
        let objects = realm.objects( NoteDataObject.self )
        try! realm.write {
            realm.delete(objects.filter("id IN %@", listId))
        }
        
        return true
    }
}
