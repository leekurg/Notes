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
    
    
    func write(_ model: NoteDataModel?){
        guard let model = model else {return}
        try! realm.write({
            
            let object = NoteDataObject()
            object.id = model.id
            object.timestamp = model.timestamp
            object.title = model.title ?? ""
            object.desc = model.description ?? ""
            object.color = model.color ?? ""
                
            realm.add(object)
        })
    }
    
    func update(_ model: NoteDataModel?) {
        guard let model = model else {return}
        
        if let object = realm.objects( NoteDataObject.self ).filter("id == %@", model.id).first {

            try! realm.write({
                object.timestamp = model.timestamp
                object.title = model.title ?? ""
                object.desc = model.description ?? ""
                object.color = model.color ?? ""
            })
        }
    }
    
    func read() -> [NoteDataModel] {
        let data = realm.objects( NoteDataObject.self )
        lastId = data.max(ofProperty: "id") as Int?
        
        return data.map { NoteDataModel(object: $0) }
    }
    
    func remove( listId: [Int]) -> Bool {
        let objects = realm.objects( NoteDataObject.self )
        try! realm.write {
            realm.delete(objects.filter("id IN %@", listId))
        }
        
        return true
    }
}
