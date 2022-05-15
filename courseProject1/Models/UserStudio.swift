//
//  UserStudio.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 08.05.2022.
//

import Foundation
import RealmSwift

class UserStudio: Object{
    
    @objc dynamic var UserStudioId = 0
    @objc dynamic var user:User?
    @objc dynamic var studio:Studio?
    
}
