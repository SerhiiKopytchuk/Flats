////
////  TestViewController.swift
////  courseProject1
////
////  Created by Serhii Kopytchuk on 04.05.2022.
////
//
//import UIKit
//import RealmSwift
//
//class TestViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print(Realm.Configuration.defaultConfiguration.fileURL ?? "")
//        
//        let user1 = User()
//        let user2 = User()
//        
//        user1.current = true
//        user1.name = "TestUser3(1)"
//        
//        user2.current = true
//        user2.name = "TestUser4(2)"
//        
//        let studio1 = Studio()
//        studio1.haveRelaxRoom = true
//        let studio2 = Studio()
//        studio2.haveRelaxRoom = false
//        
//        let realm = try! Realm()
//        realm.beginWrite()
//        
//       
//        realm.add(user1)
//        realm.add(user2)
//        realm.add(studio1)
//        realm.add(studio2)
//        user1.studios.append(studio1)
//        user1.studios.append(studio2)
//        user2.studios.append(studio1)
//        user2.studios.append(studio2)
//        
//        try! realm.commitWrite()
//        
//        let user = studio1.users[0]
//            realm.beginWrite()
//            
//            user.name = "It's working"
//            
//            try! realm.commitWrite()
//        
//        
//        print(studio1.users)
//        print(studio2.users)
//
//    }
//    
//    
//
//}
