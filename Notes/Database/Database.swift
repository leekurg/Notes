//
//  Database.swift
//  Notes
//
//  Created by Ильяяя on 07.06.2022.
//

import RealmSwift

class Database {
    private let realm: Realm!
    
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
                
            realm.add(object)
        })
    }
    
    func read() -> [NoteDataModel] {
        let data = realm.objects( NoteDataObject.self )
        
        return data.map { NoteDataModel(object: $0) }
    }
}
