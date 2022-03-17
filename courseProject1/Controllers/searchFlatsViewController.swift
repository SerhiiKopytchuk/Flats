//
//  MyFlatsViewController.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 26.02.2022.
//

import UIKit
import RealmSwift
class searchFlatsViewController: UIViewController {
    
    //MARK: - IBOutelets
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var leftConstrain: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var priceArrowUp: UIImageView!
    @IBOutlet weak var priceArrowDown: UIImageView!
    @IBOutlet weak var roomsArrowUp: UIImageView!
    @IBOutlet weak var roomsArrowDown: UIImageView!
    @IBOutlet weak var squareArrowUp: UIImageView!
    @IBOutlet weak var squareArrowDown: UIImageView!
    @IBOutlet weak var florArrowUp: UIImageView!
    @IBOutlet weak var florArrowDown: UIImageView!
    @IBOutlet weak var createdDateArrowUp: UIImageView!
    @IBOutlet weak var CreatedDateArrowDown: UIImageView!
    
    @IBOutlet weak var startPriceTextField: UITextField!
    @IBOutlet weak var endPriceTextField: UITextField!
    
    
    //MARK: - var/let
    
    
    
    
    
    let realm = try! Realm()
    let cellID = "MyFlatsTableViewCell"
    let id:Int = UserDefaults.standard.value(forKey: "userId") as! Int
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(filtersButtonPressed(_:)))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        leftConstrain.constant = filterView.frame.width
        filterView.rounded()
        
        UserDefaults.standard.set(0, forKey: "startPriceFilter")
        UserDefaults.standard.set(Int.max, forKey: "endPriceFilter")
        UserDefaults.standard.set(0, forKey: "sortBy")
        
        
        addRecognizers()
        
        
        tableView.rowHeight = 100

        
        blurView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        tableView.reloadData()
        
        if blurView.isHidden{
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed(_:)))
            rightSwipe.direction = .right
            self.view.addGestureRecognizer(rightSwipe)
        }else{
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(applyButtonPressed(_:)))
            rightSwipe.direction = .right
            self.view.addGestureRecognizer(rightSwipe)
        }
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: - IBActions
    
    @IBAction func filtersButtonPressed(_ sender: UIButton) {
        
        leftConstrain.constant = 0
        blurView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        leftConstrain.constant = filterView.frame.width
        blurView.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func DiscardSorting(_ sender: UIButton) {
        
        presentAlertWithTitle(title: "Clear all filters", message: "Do you realy want to clear all filters", options: "no", "yes") { (option) in
            switch (option){
            case 0:
                return
            case 1:
                self.startPriceTextField.text = ""
                self.endPriceTextField.text = ""
                
                UserDefaults.standard.set(0, forKey: "startPriceFilter")
                UserDefaults.standard.set(Int.max, forKey: "endPriceFilter")
                
                self.priceArrowUp.image = UIImage(named: "arrowUpGrey")
                self.priceArrowDown.image = UIImage(named: "arrowDownGrey")
                self.roomsArrowUp.image = UIImage(named: "arrowUpGrey")
                self.roomsArrowDown.image = UIImage(named: "arrowDownGrey")
                self.squareArrowUp.image = UIImage(named: "arrowUpGrey")
                self.squareArrowDown.image = UIImage(named: "arrowDownGrey")
                self.florArrowUp.image = UIImage(named: "arrowUpGrey")
                self.florArrowDown.image = UIImage(named: "arrowDownGrey")
                self.createdDateArrowUp.image = UIImage(named: "arrowUpGrey")
                self.CreatedDateArrowDown.image = UIImage(named: "arrowDownGrey")
                
                UserDefaults.standard.set(0, forKey: "sortBy")
                self.tableView.reloadData()
            default:
                return
            }
        }
        

    }
    
    @IBAction func applyButtonPressed(_ sender: UIButton) {
        
       
        let startPrice:Int = Int(startPriceTextField.text ?? "") ?? 0
        let endPrice:Int = Int(endPriceTextField.text ?? "") ?? Int.max
        
        UserDefaults.standard.set(startPrice, forKey: "startPriceFilter")
        UserDefaults.standard.set(endPrice, forKey: "endPriceFilter")

        
        tableView.reloadData()
        leftConstrain.constant = filterView.frame.width
        blurView.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    @IBAction func priceUpButtonPressed(){
        priceArrowUp.image = UIImage(named: "arrowUpGreen")
        priceArrowDown.image = UIImage(named: "arrowDownGrey")
        roomsArrowUp.image = UIImage(named: "arrowUpGrey")
        roomsArrowDown.image = UIImage(named: "arrowDownGrey")
        squareArrowUp.image = UIImage(named: "arrowUpGrey")
        squareArrowDown.image = UIImage(named: "arrowDownGrey")
        florArrowUp.image = UIImage(named: "arrowUpGrey")
        florArrowDown.image = UIImage(named: "arrowDownGrey")
        createdDateArrowUp.image = UIImage(named: "arrowUpGrey")
        CreatedDateArrowDown.image = UIImage(named: "arrowDownGrey")
        
        UserDefaults.standard.set(1, forKey: "sortBy")
    }
    @IBAction func priceDownButtonPressed(){
        priceArrowUp.image = UIImage(named: "arrowUpGrey")
        priceArrowDown.image = UIImage(named: "arrowDownRed")
        roomsArrowUp.image = UIImage(named: "arrowUpGrey")
        roomsArrowDown.image = UIImage(named: "arrowDownGrey")
        squareArrowUp.image = UIImage(named: "arrowUpGrey")
        squareArrowDown.image = UIImage(named: "arrowDownGrey")
        florArrowUp.image = UIImage(named: "arrowUpGrey")
        florArrowDown.image = UIImage(named: "arrowDownGrey")
        createdDateArrowUp.image = UIImage(named: "arrowUpGrey")
        CreatedDateArrowDown.image = UIImage(named: "arrowDownGrey")
        
        UserDefaults.standard.set(2, forKey: "sortBy")
    }
    @IBAction func roomsUpButtonPressed(){
        priceArrowUp.image = UIImage(named: "arrowUpGrey")
        priceArrowDown.image = UIImage(named: "arrowDownGrey")
        roomsArrowUp.image = UIImage(named: "arrowUpGreen")
        roomsArrowDown.image = UIImage(named: "arrowDownGrey")
        squareArrowUp.image = UIImage(named: "arrowUpGrey")
        squareArrowDown.image = UIImage(named: "arrowDownGrey")
        florArrowUp.image = UIImage(named: "arrowUpGrey")
        florArrowDown.image = UIImage(named: "arrowDownGrey")
        createdDateArrowUp.image = UIImage(named: "arrowUpGrey")
        CreatedDateArrowDown.image = UIImage(named: "arrowDownGrey")
        
        UserDefaults.standard.set(3, forKey: "sortBy")
    }
    @IBAction func roomsDownButtonPressed(){
        
        priceArrowUp.image = UIImage(named: "arrowUpGrey")
        priceArrowDown.image = UIImage(named: "arrowDownGrey")
        roomsArrowUp.image = UIImage(named: "arrowUpGrey")
        roomsArrowDown.image = UIImage(named: "arrowDownRed")
        squareArrowUp.image = UIImage(named: "arrowUpGrey")
        squareArrowDown.image = UIImage(named: "arrowDownGrey")
        florArrowUp.image = UIImage(named: "arrowUpGrey")
        florArrowDown.image = UIImage(named: "arrowDownGrey")
        createdDateArrowUp.image = UIImage(named: "arrowUpGrey")
        CreatedDateArrowDown.image = UIImage(named: "arrowDownGrey")
        
        UserDefaults.standard.set(4, forKey: "sortBy")
        
    }
    @IBAction func squareUpButtonPressed(){
        
        priceArrowUp.image = UIImage(named: "arrowUpGrey")
        priceArrowDown.image = UIImage(named: "arrowDownGrey")
        roomsArrowUp.image = UIImage(named: "arrowUpGrey")
        roomsArrowDown.image = UIImage(named: "arrowDownGrey")
        squareArrowUp.image = UIImage(named: "arrowUpGreen")
        squareArrowDown.image = UIImage(named: "arrowDownGrey")
        florArrowUp.image = UIImage(named: "arrowUpGrey")
        florArrowDown.image = UIImage(named: "arrowDownGrey")
        createdDateArrowUp.image = UIImage(named: "arrowUpGrey")
        CreatedDateArrowDown.image = UIImage(named: "arrowDownGrey")
        
        UserDefaults.standard.set(5, forKey: "sortBy")
        
    }
    @IBAction func squareDownButtonPressed(){
        priceArrowUp.image = UIImage(named: "arrowUpGrey")
        priceArrowDown.image = UIImage(named: "arrowDownGrey")
        roomsArrowUp.image = UIImage(named: "arrowUpGrey")
        roomsArrowDown.image = UIImage(named: "arrowDownGrey")
        squareArrowUp.image = UIImage(named: "arrowUpGrey")
        squareArrowDown.image = UIImage(named: "arrowDownRed")
        florArrowUp.image = UIImage(named: "arrowUpGrey")
        florArrowDown.image = UIImage(named: "arrowDownGrey")
        createdDateArrowUp.image = UIImage(named: "arrowUpGrey")
        CreatedDateArrowDown.image = UIImage(named: "arrowDownGrey")
        
        UserDefaults.standard.set(6, forKey: "sortBy")
    }
    @IBAction func florUpButtonPressed(){
        
        priceArrowUp.image = UIImage(named: "arrowUpGrey")
        priceArrowDown.image = UIImage(named: "arrowDownGrey")
        roomsArrowUp.image = UIImage(named: "arrowUpGrey")
        roomsArrowDown.image = UIImage(named: "arrowDownGrey")
        squareArrowUp.image = UIImage(named: "arrowUpGrey")
        squareArrowDown.image = UIImage(named: "arrowDownGrey")
        florArrowUp.image = UIImage(named: "arrowUpGreen")
        florArrowDown.image = UIImage(named: "arrowDownGrey")
        createdDateArrowUp.image = UIImage(named: "arrowUpGrey")
        CreatedDateArrowDown.image = UIImage(named: "arrowDownGrey")
        
        UserDefaults.standard.set(7, forKey: "sortBy")
        
    }
    @IBAction func florDownButtonPressed(){
        
        priceArrowUp.image = UIImage(named: "arrowUpGrey")
        priceArrowDown.image = UIImage(named: "arrowDownGrey")
        roomsArrowUp.image = UIImage(named: "arrowUpGrey")
        roomsArrowDown.image = UIImage(named: "arrowDownGrey")
        squareArrowUp.image = UIImage(named: "arrowUpGrey")
        squareArrowDown.image = UIImage(named: "arrowDownGrey")
        florArrowUp.image = UIImage(named: "arrowUpGrey")
        florArrowDown.image = UIImage(named: "arrowDownRed")
        createdDateArrowUp.image = UIImage(named: "arrowUpGrey")
        CreatedDateArrowDown.image = UIImage(named: "arrowDownGrey")
        
        UserDefaults.standard.set(8, forKey: "sortBy")
        
    }
    @IBAction func CreatedDateUpButtonPressed(){
        
        priceArrowUp.image = UIImage(named: "arrowUpGrey")
        priceArrowDown.image = UIImage(named: "arrowDownGrey")
        roomsArrowUp.image = UIImage(named: "arrowUpGrey")
        roomsArrowDown.image = UIImage(named: "arrowDownGrey")
        squareArrowUp.image = UIImage(named: "arrowUpGrey")
        squareArrowDown.image = UIImage(named: "arrowDownGrey")
        florArrowUp.image = UIImage(named: "arrowUpGrey")
        florArrowDown.image = UIImage(named: "arrowDownGrey")
        createdDateArrowUp.image = UIImage(named: "arrowUpGreen")
        CreatedDateArrowDown.image = UIImage(named: "arrowDownGrey")
        
        UserDefaults.standard.set(9, forKey: "sortBy")
        
    }
    @IBAction func CreatedDateDownButtonPressed(){
        
        priceArrowUp.image = UIImage(named: "arrowUpGrey")
        priceArrowDown.image = UIImage(named: "arrowDownGrey")
        roomsArrowUp.image = UIImage(named: "arrowUpGrey")
        roomsArrowDown.image = UIImage(named: "arrowDownGrey")
        squareArrowUp.image = UIImage(named: "arrowUpGrey")
        squareArrowDown.image = UIImage(named: "arrowDownGrey")
        florArrowUp.image = UIImage(named: "arrowUpGrey")
        florArrowDown.image = UIImage(named: "arrowDownGrey")
        createdDateArrowUp.image = UIImage(named: "arrowUpGrey")
        CreatedDateArrowDown.image = UIImage(named: "arrowDownRed")
        
        UserDefaults.standard.set(10, forKey: "sortBy")
    }
    
    //MARK: - func
    
    func checkForNumbersInFilters(){

    }
    
    func addRecognizers(){
        let recognizerPriceUp = UITapGestureRecognizer(target: self, action: #selector(priceUpButtonPressed))
        let recognizerPriceDown = UITapGestureRecognizer(target: self, action: #selector(priceDownButtonPressed))
        let recognizerRoomsUp = UITapGestureRecognizer(target: self, action: #selector(roomsUpButtonPressed))
        let recognizerRoomsDown = UITapGestureRecognizer(target: self, action: #selector(roomsDownButtonPressed))
        let recognizerSquareUp = UITapGestureRecognizer(target: self, action: #selector(squareUpButtonPressed))
        let recognizerSquareDown = UITapGestureRecognizer(target: self, action: #selector(squareDownButtonPressed))
        let recognizerFlorUp = UITapGestureRecognizer(target: self, action: #selector(florUpButtonPressed))
        let recognizerFlorDown = UITapGestureRecognizer(target: self, action: #selector(florDownButtonPressed))
        let recognizerCreatedDateUp = UITapGestureRecognizer(target: self, action: #selector(CreatedDateUpButtonPressed))
        let recognizerCreatedDateDown = UITapGestureRecognizer(target: self, action: #selector(CreatedDateDownButtonPressed))
        
        priceArrowUp.isUserInteractionEnabled = true
        priceArrowUp.addGestureRecognizer(recognizerPriceUp)
        priceArrowDown.isUserInteractionEnabled = true
        priceArrowDown.addGestureRecognizer(recognizerPriceDown)
        roomsArrowUp.isUserInteractionEnabled = true
        roomsArrowUp.addGestureRecognizer(recognizerRoomsUp)
        roomsArrowDown.isUserInteractionEnabled = true
        roomsArrowDown.addGestureRecognizer(recognizerRoomsDown)
        squareArrowUp.isUserInteractionEnabled = true
        squareArrowUp.addGestureRecognizer(recognizerSquareUp)
        squareArrowDown.isUserInteractionEnabled = true
        squareArrowDown.addGestureRecognizer(recognizerSquareDown)
        florArrowUp.isUserInteractionEnabled = true
        florArrowUp.addGestureRecognizer(recognizerFlorUp)
        florArrowDown.isUserInteractionEnabled = true
        florArrowDown.addGestureRecognizer(recognizerFlorDown)
        createdDateArrowUp.isUserInteractionEnabled = true
        createdDateArrowUp.addGestureRecognizer(recognizerCreatedDateUp)
        CreatedDateArrowDown.isUserInteractionEnabled = true
        CreatedDateArrowDown.addGestureRecognizer(recognizerCreatedDateDown)
        
    }
    
}


//MARK: - Extensions
extension searchFlatsViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let user = realm.objects(User.self).filter("current == true").first
        
        let startPrice: Int = UserDefaults.standard.object(forKey: "startPriceFilter") as? Int ?? 0
        let endPrice: Int = UserDefaults.standard.object(forKey: "endPriceFilter") as? Int ?? Int.max
        
        let flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").filter("price > \(startPrice)  AND price < \(endPrice)")
        
        return flats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MyFlatsTableViewCell
        
        
        //sort that
        let sortBy = UserDefaults.standard.object(forKey: "sortBy") as! Int
        let startPrice: Int = UserDefaults.standard.object(forKey: "startPriceFilter") as? Int ?? 0
        let endPrice: Int = UserDefaults.standard.object(forKey: "endPriceFilter") as? Int ?? Int.max
    
        let user = realm.objects(User.self).filter("current == true").first
        
        let flats: Results<Flat>
        
        switch sortBy{
        case 0:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").filter("price > \(startPrice)  AND price < \(endPrice)")
        case 1:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").sorted(byKeyPath: "price", ascending: true).filter("price > \(startPrice)  AND price < \(endPrice)")
        case 2:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").sorted(byKeyPath: "price", ascending: false).filter("price > \(startPrice)  AND price < \(endPrice)")
        case 3:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").sorted(byKeyPath: "rooms", ascending: true).filter("price > \(startPrice)  AND price < \(endPrice)")
        case 4:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").sorted(byKeyPath: "rooms", ascending: false).filter("price > \(startPrice)  AND price < \(endPrice)")
        case 5:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").sorted(byKeyPath: "square", ascending: true).filter("price > \(startPrice)  AND price < \(endPrice)")
        case 6:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").sorted(byKeyPath: "square", ascending: false).filter("price > \(startPrice)  AND price < \(endPrice)")
        case 7:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").sorted(byKeyPath: "floorNum", ascending: true).filter("price > \(startPrice)  AND price < \(endPrice)")
        case 8:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").sorted(byKeyPath: "floorNum", ascending: false).filter("price > \(startPrice)  AND price < \(endPrice)")
        case 9:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").sorted(byKeyPath: "createdDate", ascending: true).filter("price > \(startPrice)  AND price < \(endPrice)")
        case 10:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").sorted(byKeyPath: "createdDate", ascending: false).filter("price > \(startPrice)  AND price < \(endPrice)")
        default:
            flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)").filter("price > \(startPrice)  AND price < \(endPrice)")
        }
        
        
        
        
        let flat = flats[indexPath.row]
        
        let flatImage = Manager.shared.retrieveImage(forKey: "\(flat.id )FlatImage", inStorageType: .fileSystem)
        
        cell.configuration(name: (flat.name ?? ""), price: String(flat.price ) + "$" ,image: flatImage ?? UIImage())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = realm.objects(User.self).filter("current == true").first
        let controller = self.storyboard?.instantiateViewController(withIdentifier:  "buyFlatViewController") as! buyFlatViewController
        let flats = realm.objects(Flat.self).filter("owner.id != \(user?.id ?? 0)")
        let flat = flats[indexPath.row]
        controller.id = flat.id
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
