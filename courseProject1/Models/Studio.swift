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
    
    
    static internal func getSearchStudios()->[Studio]{

        let sortBy = UserDefaults.standard.object(forKey: "sortBy") as! Int
        let startPrice: Int = UserDefaults.standard.object(forKey: "startPriceFilter") as? Int ?? 0
        let endPrice: Int = UserDefaults.standard.object(forKey: "endPriceFilter") as? Int ?? Int.max

        let realm = try! Realm()

        let user = realm.objects(User.self).filter("current == true").first
        let userStudios = realm.objects(UserStudio.self).filter("user.id != \(user?.id ?? 0)")
        var studioArray:[Studio] = []
        for userStuio in userStudios{
            studioArray.append(userStuio.studio ?? Studio())
        }

        let myStudios = Array(realm.objects(UserStudio.self).filter("user.id == \(user?.id ?? 0)"))
        
        for i in studioArray.indices.reversed(){
            for j in myStudios.indices{
                if studioArray[i].id == myStudios[j].studio?.id{
                    studioArray.remove(at: i)
                    break
                }
            }
        }

        studioArray = studioArray.filter { studio in
            if studio.price > startPrice{
                if studio.price < endPrice{
                    return true
                }
            }
            return false
        }

        for i in studioArray.indices.reversed(){
            for j in studioArray.indices.reversed(){
                if i != j{
                    if studioArray[i].id == studioArray[j].id{
                        if i > j{
                            studioArray.remove(at: i)
                            break
                        }else{
                            studioArray.remove(at: j)
                            break
                        }

                    }
                }
            }
        }

        switch sortBy{
        case 1:
            studioArray = studioArray.sorted(by: {$0.price > $1.price})
        case 2:
            studioArray = studioArray.sorted(by: {$0.price < $1.price})
        case 3:
            studioArray = studioArray.sorted(by: {$0.rooms > $1.rooms})
        case 4:
            studioArray = studioArray.sorted(by: {$0.rooms < $1.rooms})
        case 5:
            studioArray = studioArray.sorted(by: {$0.square > $1.square})
        case 6:
            studioArray = studioArray.sorted(by: {$0.square < $1.square})
        case 7:
            studioArray = studioArray.sorted(by: {$0.floorNum > $1.floorNum})
        case 8:
            studioArray = studioArray.sorted(by: {$0.floorNum < $1.floorNum})
        case 9:
            studioArray = studioArray.sorted(by: {$0.createdDate > $1.createdDate})
        case 10:
            studioArray = studioArray.sorted(by: {$0.createdDate < $1.createdDate})
        default:
            studioArray = studioArray.sorted(by: {$0.floorNum < $1.floorNum})
        }

        return studioArray
    }
    

}
