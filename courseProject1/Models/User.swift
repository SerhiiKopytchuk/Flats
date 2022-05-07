//
//  User.swift
//  courseProjectFlats
//
//  Created by Serhii Kopytchuk on 18.02.2022.
//

import Foundation
import RealmSwift


class User: Object{
    
    @objc dynamic var id = 0
    @objc dynamic var name:String?
    @objc dynamic var password:String?
    @objc dynamic var phoneNumber: Double = 0.0
    
    @objc dynamic var current = true
    @objc dynamic var isAutorized = false
    @objc dynamic var appPassword:String? = ""
    
    let flats = List<Flat>()
    let studios = List<Studio>()

    
    var friendsId = List<Int>()
    
    static func getCurrentUser() -> User {
        let realm = try! Realm()

        return realm.objects(User.self).filter("current == true").first ?? User()
    }
    
}
