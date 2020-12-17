//
//  UserMapList.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 2..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import Firebase
import CoreLocation
import MapKit
import CoreData


class UserMapList: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating {

    @IBOutlet weak var indicatorview: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    @IBOutlet weak var tableview: UITableView!

    var ref: DatabaseReference!
    var refHandle: UInt!
    
    var storage: Storage!
    
    var userList = [Userdata]()
    var filterList = [Userdata]()
    var searchFilterList = [Userdata]()
    
    var databaseHandle:DatabaseHandle?
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var myaccount:String = ""
    var passAccount:String = ""
    var lang:Double = 0.0
    var passlang:Double = 0.0
    var long:Double = 0.0
    var passlong:Double = 0.0
    var myname:String = ""
    var passmyname:String = ""
    var myaddress:String = ""
    var mycategory:String = ""
    var passcategory:String = ""
    
    var userListCount:Int = 0
    
    var getkindTag:Int = 0
    var gettrafTag:Int = 0
    var getdistTag:Int = 0
    var kindpicks = ["전체","음식점","카페"]
    var trafficpicks = ["전체","쾌적","원활","혼잡"]
    var distancepicks = ["전체","300m","500m","1km"]
    var intdistance = [0, 300, 500, 1000]
    
    var mylocal = CLLocation()
    var mylatitude:Double = 0.0
    var mylongitude:Double = 0.0
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchActive : Bool = false
    
    @IBAction func GoHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "기본 바탕")!
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(image, for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
        }
        
        indicator.stopAnimating()
        indicatorview.isHidden = true
        
        tableview.delegate = self
        tableview.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false

        searchController.searchBar.placeholder = "가게명을 적어주세요 !!"
        searchController.searchBar.barTintColor = UIColor(red: 45/255, green: 81/255, blue: 66/255, alpha: 1)
        
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
        tableview.tableHeaderView = searchController.searchBar

        let defaults = UserDefaults.standard
        mylatitude = defaults.double(forKey: "myLatitude")
        mylongitude = defaults.double(forKey: "myLongitude")
        
        mylocal = CLLocation(latitude: mylatitude, longitude: mylongitude)
        
        ref = Database.database().reference()
        
        tableview.reloadData()
        refreshControl.tintColor = UIColor.orange
        refreshControl.attributedTitle = NSAttributedString(string:"새로고침을 하는 중입니다...", attributes:[NSAttributedStringKey.foregroundColor : refreshControl.tintColor])
        
        refreshControl.addTarget(self, action: #selector(UserMapList.refresh), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *){
            tableview.refreshControl = refreshControl
        }else{
            tableview.addSubview(refreshControl)
        }
    }
    
    @objc func refresh(){
        fetchUsers()
        refreshControl.endRefreshing()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func filterContent(searchText:String){
        self.filterList.removeAll()
        
        self.filterList = self.userList.filter{ user in
            let username = user.myname
            
            return (username?.lowercased().contains(searchText.lowercased()))!
        }

        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searchController.isActive && searchController.searchBar.text != "") || gettrafTag != 0 || getkindTag != 0 || getdistTag != 0{
            return filterList.count
        }
        
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserMapListCell
        
        if (searchController.isActive && searchController.searchBar.text != "") || gettrafTag != 0 || getkindTag != 0 || getdistTag != 0{
            cell.MyRestaurant.text = filterList[indexPath.row].myname
            cell.Mylocation.text = filterList[indexPath.row].myaddress
            let reslocal:CLLocation = CLLocation(latitude: filterList[indexPath.row].mylatitude!, longitude: filterList[indexPath.row].mylongitude!)
            let cen:Int = Int(reslocal.distance(from: mylocal))
            cell.resdistance.text = "\(String(cen)) m"
        }else{
            cell.MyRestaurant.text = userList[indexPath.row].myname
            cell.Mylocation.text = userList[indexPath.row].myaddress
            let reslocal:CLLocation = CLLocation(latitude: userList[indexPath.row].mylatitude!, longitude: userList[indexPath.row].mylongitude!)
            let cen:Int = Int(reslocal.distance(from: mylocal))
            cell.resdistance.text = "\(String(cen)) m"
        }

        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        filterContent(searchText: self.searchController.searchBar.text!)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.showsCancelButton = true
    }
    
    func fetchUsers(){
        indicatorview.isHidden = false
        indicator.startAnimating()
        
        self.userList.removeAll()
        self.filterList.removeAll()
        
        refHandle = ref.child("Users").observe(.childAdded, with: { (snapshot) in
            
            self.userListCount = snapshot.children.allObjects.count
            
            for snap in snapshot.children.allObjects as! [DataSnapshot]{
                let dictionary = snap.value as? [String : Any]

                let getname = dictionary?["myname"]
                let getaddress = dictionary?["myaddress"]
                let getaccount = dictionary?["myaccount"]
                let getlang = dictionary?["mylatitude"]
                let getlong = dictionary?["mylongitude"]
                let getcategory = dictionary?["mycategory"]
                let getnow = dictionary?["now"]
                
                let post = Userdata(name: getname as? String, address: getaddress as? String, account: getaccount as? String, latitude: getlang as? Double, longitude: getlong as? Double, category: getcategory as? String, now: getnow as? String)

                self.userList.append(post)
                if self.userList.count == self.userListCount{
                    if self.getkindTag == 0{
                        self.filterList = self.userList
                    }else if self.getkindTag == 1{
                        self.filterList = self.userList.filter{($0.mycategory?.contains(self.kindpicks[1]))!}
                    }else if self.getkindTag == 2{
                        self.filterList = self.userList.filter{($0.mycategory?.contains(self.kindpicks[2]))!}
                    }
                    
                    if self.gettrafTag == 0{
                        
                    }else if self.gettrafTag == 1{
                        self.filterList = self.filterList.filter{($0.mynow?.contains(self.trafficpicks[1]))!}
                    }else if self.gettrafTag == 2{
                        self.filterList = self.filterList.filter{($0.mynow?.contains(self.trafficpicks[2]))!}
                    }else if self.gettrafTag == 3{
                        self.filterList = self.filterList.filter{($0.mynow?.contains(self.trafficpicks[3]))!}
                    }
                    
                    if self.getdistTag == 0{

                    }else if self.getdistTag == 1{
                        self.filterList = self.filterList.filter{Int(CLLocation(latitude: $0.mylatitude!,longitude: $0.mylongitude!).distance(from: self.mylocal)) <= self.intdistance[1]}
                    }else if self.getdistTag == 2{
                        self.filterList = self.filterList.filter{Int(CLLocation(latitude: $0.mylatitude!,longitude: $0.mylongitude!).distance(from: self.mylocal)) <= self.intdistance[2]}
                    }else if self.getdistTag == 3{
                        self.filterList = self.filterList.filter{Int(CLLocation(latitude: $0.mylatitude!,longitude: $0.mylongitude!).distance(from: self.mylocal)) <= self.intdistance[3]}
                    }
                    
                    self.tableview.reloadData()
                    
                    self.indicatorview.isHidden = true
                    self.indicator.stopAnimating()
                }
            }
        }, withCancel: nil)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (searchController.isActive && searchController.searchBar.text != "") || gettrafTag != 0 || getkindTag != 0 || getdistTag != 0{
            self.passAccount = filterList[indexPath.row].myaccount!
            self.passlang = filterList[indexPath.row].mylatitude!
            self.passlong = filterList[indexPath.row].mylongitude!
            self.passmyname = filterList[indexPath.row].myname!
            self.passcategory = filterList[indexPath.row].mycategory!
            
        }else{
            self.passAccount = userList[indexPath.row].myaccount!
            self.passlang = userList[indexPath.row].mylatitude!
            self.passlong = userList[indexPath.row].mylongitude!
            self.passmyname = userList[indexPath.row].myname!
            self.passcategory = userList[indexPath.row].mycategory!
        }

        
        
        performSegue(withIdentifier: "GoUserMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "GoUserMap") {

            let navVc = segue.destination as! UINavigationController
            let chatVc = navVc.viewControllers.first as! UserMap
            
            chatVc.getID = passAccount
            chatVc.mylat = passlang
            chatVc.mylon = passlong
            chatVc.name = passmyname
            chatVc.mycat = passcategory
        }
    }
}

