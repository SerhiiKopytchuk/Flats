//
//  FlatClass.swift
//  courseProjectFlats
//
//  Created by Serhii Kopytchuk on 18.02.2022.
//

import Foundation
import RealmSwift

class Flat: Object{
    @objc dynamic var name:String?
    @objc dynamic var about:String?
    @objc dynamic var sity:String?
    @objc dynamic var street:String?

    
    
    @objc dynamic var isSold = false
    @objc dynamic var createdDate = Date()
    
    @objc dynamic var price = 0
    @objc dynamic var square = 0
    @objc dynamic var rooms = 0
    @objc dynamic var BuildingNum = 0
    @objc dynamic var FlatNum = 0
    @objc dynamic var floorNum = 0
    
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    
    @objc dynamic var owner: User?
}
