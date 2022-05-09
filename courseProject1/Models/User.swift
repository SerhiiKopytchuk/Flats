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
    
    static internal func getMyStudios()->[Studio]{
        let realm = try! Realm()
        let user = realm.objects(User.self).filter("current == true").first
        let userStudios = realm.objects(UserStudio.self).filter("user.id == \(user?.id ?? 0)")
        var studioArray:[Studio] = []
        for userStuio in userStudios{
            studioArray.append(userStuio.studio ?? Studio())
        }
        return studioArray
    }
}
