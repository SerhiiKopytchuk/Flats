//
//  Studio.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 21.04.2022.
//

import Foundation
import RealmSwift

class Studio:Flat{
    
    @objc dynamic var peopleCapacity = 0
    @objc dynamic var haveShower = false
    @objc dynamic var haveRelaxRoom = false
    
    let owners = LinkingObjects(fromType: User.self, property: "studios")
}
