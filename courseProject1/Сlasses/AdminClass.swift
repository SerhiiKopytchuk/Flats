//
//  AdminClass.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 21.04.2022.
//

import Foundation
import RealmSwift

class Admin: User{
    static func getCountOfUsers() -> Int{
        let realm = try! Realm()
        return realm.objects(User.self).count
    }
    
    static func getCountOfFlats() -> Int{
        let realm = try! Realm()
        return realm.objects(Flat.self).count
    }
    
    static func getSumPriceOfAllFlats() -> Double{
        let realm = try! Realm()
        var sum:Double = 0.0
        let flats = realm.objects(Flat.self)
        for flat in flats{
            sum += Double(flat.price)
        }
        return sum
    }
    
    static func getAverageValueOfFlat() ->Double{
        let realm = try! Realm()
        var sum:Double = 0.0
        let flats = realm.objects(Flat.self)
        for flat in flats{
            sum += Double(flat.price)
        }
        let average = sum/Double(flats.count)
        return average
    }
    
}
