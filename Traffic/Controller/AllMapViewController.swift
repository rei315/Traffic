//
//  AllMapViewController.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 19..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import Firebase
import CoreData

class MyPointAnnotation : MKPointAnnotation {
    var pinTintColor: UIColor?
    var ID: String = ""
    var now: String = ""
    var whatimage: UIImage?
    var tag: Int = 0
}


class AllMapViewController: UIViewController,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MKMapViewDelegate {
    
    @IBOutlet weak var Traffic: UITextField!
    @IBOutlet weak var Distance: UITextField!
    
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    

    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    var Restaurants = [String:AnyObject]()
    
    var getID:String = ""
    var getName:String = ""
    var getAddress: String = ""
    var getAccount: String = ""
    var getCategory: String = ""
    var getnow:String = ""
    
    var Relon:Double = 0.0
    var Relat:Double = 0.0
    
    var gotInformation = [Userdata]()
    var filterInformation = [Userdata]()
    
    var myLoc = CLLocation()
    
    var loc = CLLocation()
    
    var pinAnnotationView:MKPinAnnotationView!
    var locationManager = CLLocationManager()
    
    var mylatitude:Double = 0.0
    var mylongitude:Double = 0.0
    var Mylocation:String = ""
    
    var picker2 = UIPickerView()
    var picker3 = UIPickerView()

    var trafficpicks = ["전체","쾌적","원활","혼잡"]
    var distancepicks = ["전체","300m","500m","1km"]
    var intdistance:[Int] = [0, 300, 500, 1000]
    var count:Int = 0
    
    var objects = [MKAnnotation]()

    var annots = [MyPointAnnotation]()
    
    var selectedPin: String = ""
    var now:String = ""
    
    var datacount:Int = 0
    
    var tag:Int = 0
    let my = MyPointAnnotation()
    var mylocal = CLLocation()
    var selectdistance: Int = 0
    var selecttraffic: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //거리 몇으로 할지
        
        let image = UIImage(named: "기본 바탕")!
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(image, for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
        }
        
        let defaults = UserDefaults.standard
        
        Mylocation = defaults.string(forKey: "myLocation")!
        
        mylatitude = defaults.double(forKey: "myLatitude")
        mylongitude = defaults.double(forKey: "myLongitude")
        
        selectdistance = intdistance[0]
        selecttraffic = trafficpicks[0]
        
        mapview.delegate = self

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AllMapViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        picker2.delegate = self
        picker2.dataSource = self
        Traffic.inputAccessoryView = toolBar
        Traffic.text = trafficpicks[0]
        Traffic.tintColor = UIColor.clear
        Traffic.inputView = picker2
        
        picker3.delegate = self
        picker3.dataSource = self
        Distance.inputAccessoryView = toolBar
        Distance.text = distancepicks[0]
        Distance.tintColor = UIColor.clear
        Distance.inputView = picker3
        

        ref = Database.database().reference()

//         위치랑 가게 거리 구하기 M 단위로
        mylocal = CLLocation(latitude: mylatitude, longitude: mylongitude)
//        print("distance: ",dis,"m")
        
        //위치 설정
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

        loadingBar.stopAnimating()
        loadingView.isHidden = true
        
        fetch()
        
        mylocationPin()
    }

    func mylocationPin(){
        my.title = "내 위치"
        my.coordinate = CLLocationCoordinate2DMake(mylatitude, mylongitude)
        my.tag = 1
        //        my.now = "없음"
        my.whatimage = UIImage(named: "mylocation")
        mapview.addAnnotation(my)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle{
            let renderer = MKCircleRenderer.init(overlay: circle)
            renderer.fillColor = UIColor.red.withAlphaComponent(0.02)
            renderer.strokeColor = UIColor.red.withAlphaComponent(0.3)
            renderer.lineWidth = 2
            
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    @objc func donePicker() {
        view.endEditing(true)
    }

    func getdistance(){
        
        for i in 0...count{
            let anno = MyPointAnnotation()
            
            let this:CLLocation = CLLocation(latitude: gotInformation[i].mylatitude!, longitude: gotInformation[i].mylongitude!)
            let distance:Int = Int(this.distance(from: mylocal))
            
            if distance < selectdistance{
                anno.title = gotInformation[i].myname
                anno.ID = gotInformation[i].myaccount!
                anno.now = gotInformation[i].mynow!
                anno.coordinate = CLLocationCoordinate2DMake(gotInformation[i].mylatitude!, gotInformation[i].mylongitude!)
                
                annots.append(anno)
            }
        }

        mapview.addAnnotations(annots)
        if self.loadingView.isHidden == false && self.loadingBar.isAnimating == true{
            self.loadingView.isHidden = true
            self.loadingBar.stopAnimating()
        }
    }
    
    func alldistance(){
        
        for i in 0...count{
            let anno = MyPointAnnotation()
            
            anno.title = gotInformation[i].myname
            anno.ID = gotInformation[i].myaccount!
            anno.now = gotInformation[i].mynow!
            anno.coordinate = CLLocationCoordinate2DMake(gotInformation[i].mylatitude!, gotInformation[i].mylongitude!)
                
            annots.append(anno)
        }
        
        mapview.addAnnotations(annots)
        if self.loadingView.isHidden == false && self.loadingBar.isAnimating == true{
            self.loadingView.isHidden = true
            self.loadingBar.stopAnimating()
        }
    }
    
    func reloadpin(){
        
        let anno = MyPointAnnotation()

        anno.title = gotInformation[count].myname
        anno.ID = gotInformation[count].myaccount!
        anno.now = gotInformation[count].mynow!
        anno.coordinate = CLLocationCoordinate2DMake(gotInformation[count].mylatitude!, gotInformation[count].mylongitude!)
            
        annots.append(anno)

        mapview.addAnnotations(annots)
        
        Traffic.text = trafficpicks[0]
//        picker2.reloadAllComponents()
        
        Distance.text = distancepicks[0]
//        picker3.reloadAllComponents()
        
        if self.loadingView.isHidden == false && self.loadingBar.isAnimating == true{
            self.loadingView.isHidden = true
            self.loadingBar.stopAnimating()
        }
    }
    
    func getFetchKind(objectArray: [Userdata]){

        let FetchKindCount = objectArray.count - 1

        if(FetchKindCount < 0){
            print("none")
        }else{
            for i in 0...FetchKindCount{
                
                let anno = MyPointAnnotation()
                
                let this:CLLocation = CLLocation(latitude: objectArray[i].mylatitude!, longitude: objectArray[i].mylongitude!)
                let distance:Int = Int(this.distance(from: mylocal))
                
                if distance < selectdistance{
                    anno.title = objectArray[i].myname
                    anno.ID = objectArray[i].myaccount!
                    anno.now = objectArray[i].mynow!
                    anno.coordinate = CLLocationCoordinate2DMake(objectArray[i].mylatitude!, objectArray[i].mylongitude!)
                    annots.append(anno)
                }
            }
            mapview.addAnnotations(annots)
        }
        if self.loadingView.isHidden == false && self.loadingBar.isAnimating == true{
            self.loadingView.isHidden = true
            self.loadingBar.stopAnimating()
        }
    }
    
    func getFetchKindandAll(objectArray: [Userdata]){
        
        let FetchKindCount = objectArray.count - 1
        
        if(FetchKindCount < 0){
            print("none")
        }else{
            for i in 0...FetchKindCount{
                
                let anno = MyPointAnnotation()
                
                    anno.title = objectArray[i].myname
                    anno.ID = objectArray[i].myaccount!
                    anno.now = objectArray[i].mynow!
                    anno.coordinate = CLLocationCoordinate2DMake(objectArray[i].mylatitude!, objectArray[i].mylongitude!)
                    annots.append(anno)
            }
            mapview.addAnnotations(annots)
        }
        if self.loadingView.isHidden == false && self.loadingBar.isAnimating == true{
            self.loadingView.isHidden = true
            self.loadingBar.stopAnimating()
        }
    }
 
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        tag = (annotation as! MyPointAnnotation).tag
        
        let pinView = mapview.dequeueReusableAnnotationView(withIdentifier: "inform") as? MKPinAnnotationView
        
        if tag == 1{
            
            var mypinView = mapview.dequeueReusableAnnotationView(withIdentifier: "inform")
            
            if mypinView == nil{
                mypinView = MKAnnotationView(annotation: annotation, reuseIdentifier: "inform")
                
                mypinView!.canShowCallout=true
                
            }else{
                mypinView!.annotation = annotation;
            }

            if let annotation = annotation as? MyPointAnnotation{
                mypinView!.image = annotation.whatimage

                return mypinView
            }
        }else{
            
            var mypinState = mapview.dequeueReusableAnnotationView(withIdentifier: "inform")
            
            if mypinState == nil{
                mypinState = MKAnnotationView(annotation: annotation, reuseIdentifier: "inform")
                
                mypinState!.canShowCallout=true
                
            }else{
                mypinState!.annotation = annotation;
            }
            
            now = (annotation as! MyPointAnnotation).now

//            if let annotationA = annotation as? MyPointAnnotation{
            
                if now == trafficpicks[3]{
                    //                pinView?.pinTintColor = UIColor.red
                    //                pinView?.image = UIImage(named: "신호등빨강")
                    mypinState?.image = UIImage(named: "신호등Red")
                }else if now == trafficpicks[2]{
                    //                pinView?.pinTintColor = UIColor.orange
                    //                pinView?.image = UIImage(named: "신호등노랑")
                    mypinState?.image = UIImage(named: "신호등Orange")
                }else if now == trafficpicks[1]{
                    //                pinView?.pinTintColor = UIColor.green
                    //                pinView?.image = UIImage(named: "신호등초록")
                    mypinState?.image = UIImage(named: "신호등Green")
                }else{
                    //            pinView?.pinTintColor = UIColor.black
                }
            
            let btn = UIButton(type: .infoDark) as UIButton
            mypinState?.rightCalloutAccessoryView = btn
            
                return mypinState
//            }
            
            
//            if pinView == nil{
//                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "inform")
//
//                pinView?.canShowCallout=true
//
//            }else{
//                pinView?.annotation = annotation;
//            }
//
//            now = (annotation as! MyPointAnnotation).now
//
//            if now == trafficpicks[3]{
////                pinView?.pinTintColor = UIColor.red
//                pinView?.image = UIImage(named: "신호등빨강")
//            }else if now == trafficpicks[2]{
////                pinView?.pinTintColor = UIColor.orange
//                pinView?.image = UIImage(named: "신호등노랑")
//            }else if now == trafficpicks[1]{
////                pinView?.pinTintColor = UIColor.green
//                pinView?.image = UIImage(named: "신호등초록")
//            }else{
//                //            pinView?.pinTintColor = UIColor.black
//            }
//
//            let btn = UIButton(type: .infoDark) as UIButton
//
//            pinView?.rightCalloutAccessoryView = btn
//
//            return pinView
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        selectedPin = (view.annotation as! MyPointAnnotation).ID

        performSegue(withIdentifier: "Information", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Information") {
            let navVc = segue.destination as! UITabBarController
            let tagVc = navVc.viewControllers?.first as! UINavigationController
            let vc = tagVc.viewControllers.first as! GetTrafficForUser
            vc.getID = selectedPin
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let center = CLLocationCoordinate2DMake(mylatitude, mylongitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapview.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func ReloadFetch(_ sender: Any) {
        if loadingView.isHidden == true{
            loadingView.isHidden = false
            loadingBar.startAnimating()
            fetch()
        }
    }
    func fetch()
    {
        if self.loadingView.isHidden == true && self.loadingBar.isAnimating == false{
            self.loadingView.isHidden = false
            self.loadingBar.startAnimating()
        }
        
        gotInformation.removeAll()
        
        self.mapview.removeAnnotations(annots)
        annots.removeAll()
        
        databaseHandle = ref.child("Users").observe(.childAdded, with: { (snapshot) in
            for snap in snapshot.children.allObjects as! [DataSnapshot]{
                self.Restaurants = snap.value as! [String : AnyObject]
                
                self.getID = self.Restaurants["myaccount"] as! String
                self.getCategory = self.Restaurants["mycategory"] as! String
                self.getAddress = self.Restaurants["myaddress"] as! String
                self.getName = self.Restaurants["myname"] as! String
                self.Relat = self.Restaurants["mylatitude"] as! Double
                self.Relon = self.Restaurants["mylongitude"] as! Double
                self.getnow = self.Restaurants["now"] as! String
                //
                let Information = Userdata(name: self.getName, address: self.getAddress, account: self.getID, latitude: self.Relat, longitude: self.Relon, category: self.getCategory, now: self.getnow)
                self.gotInformation.append(Information)

                self.count = self.gotInformation.count - 1
                self.reloadpin()
            }
        }, withCancel: nil)
    }
    
    
    
    @IBAction func GoHome(_ sender: Any) {
        if loadingView.isHidden == true{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == picker2{
            return trafficpicks.count
        }
        if pickerView == picker3{
            return distancepicks.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == picker2{
            
            self.mapview.removeAnnotations(annots)
            annots.removeAll()
            
            Traffic.text = trafficpicks[row]
                
            if trafficpicks[row] == trafficpicks[0]{
                selecttraffic = trafficpicks[row]
                if selectdistance == intdistance[0]{
                    alldistance()
                }else{
                    getdistance()
                }
            }else{
                selecttraffic = trafficpicks[row]
                if selectdistance == intdistance[0]{
                    filterInformation = gotInformation.filter{($0.mynow?.contains(trafficpicks[row]))!}
                    getFetchKindandAll(objectArray: filterInformation)
                }else{
                    filterInformation = gotInformation.filter{($0.mynow?.contains(trafficpicks[row]))!}
                    getFetchKind(objectArray: filterInformation)
                }
            }
        }
        
        if pickerView == picker3{
            
            self.mapview.removeAnnotations(annots)
            annots.removeAll()
            
            Distance.text = distancepicks[row]
            
            self.mapview.removeOverlays(mapview.overlays)
            if selecttraffic == trafficpicks[0]
            {
                if distancepicks[row] == distancepicks[0]{
                    selectdistance = intdistance[row]
                    alldistance()
                }else{
                    selectdistance = intdistance[row]
                    let center = CLLocationCoordinate2D(latitude: mylatitude, longitude: mylongitude)
                    mapview.add(MKCircle(center: center, radius: CLLocationDistance(selectdistance)))
                    getdistance()
                }
            }else{
                if distancepicks[row] == distancepicks[0]{
                    selectdistance = intdistance[row]
                    getFetchKindandAll(objectArray: filterInformation)
                }else{
                    selectdistance = intdistance[row]
                    let center = CLLocationCoordinate2D(latitude: mylatitude, longitude: mylongitude)
                    mapview.add(MKCircle(center: center, radius: CLLocationDistance(selectdistance)))
                    getFetchKind(objectArray: filterInformation)
                }
            }
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == picker2{
            return trafficpicks[row]
        }
        if pickerView == picker3{
            return distancepicks[row]
        }
        return ""
    }

}
