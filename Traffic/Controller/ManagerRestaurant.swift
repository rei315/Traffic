//
//  ManagerRestaurant.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 1..
//  Copyright © 2017년 김민국. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import Firebase
import CoreData

class ManagerRestaurant: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var setlocationfield: UITextField!
    @IBOutlet weak var centerIMG: UIImageView!
    
    var ref: DatabaseReference!
    
    var locationManager = CLLocationManager()
    var searching:Bool = false;
    
    var mylat:CLLocationDegrees = 0.0
    var mylon:CLLocationDegrees = 0.0
    var name:String = ""
    var getphone:String = ""
    var phone:UInt = 0
    var address:String = ""
    var getpeople:String = ""
    var people:Int = 0
    var category:String = ""
    var myimage: UIImage?
    
    var myrestaurant : [String:Any] = [:]
    
    var country:String = ""
    var area:String = ""
    var locality:String = ""
    var fare:String = ""
    var Mylocation:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let image = UIImage(named: "기본 바탕")!
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(image, for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
        }
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: setlocationfield.frame.height))
        setlocationfield.leftView = paddingView
        setlocationfield.leftViewMode = UITextFieldViewMode.always
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[0]
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, span)
        
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancle(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        centerIMG.isHidden = false
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if animated != true{
            centerIMG.isHidden = true
            
            mylat = mapView.centerCoordinate.latitude
            mylon = mapView.centerCoordinate.longitude
            
            let center = CLLocation(latitude: mylat, longitude: mylon)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: mylat, longitude: mylon)
            annotation.title = "내 가게 위치 입니다."
            
            self.mapView.removeAnnotations(mapView.annotations)
            self.mapView.addAnnotation(annotation)
            
            CLGeocoder().reverseGeocodeLocation(center) { (placemark, error) in
                if error != nil{
                    self.setlocationfield.text = "정확한 위치에 가주세요"
                }else{
                    if let place = placemark?[0]{
                        
                        if place.country != nil && place.administrativeArea != nil && place.locality != nil && place.thoroughfare != nil{
//                            self.country = (place.country)!
//                            self.area = (place.administrativeArea)!
//                            self.locality = (place.locality)!
//                            self.fare = (place.thoroughfare)!
//                            self.Mylocation = "\(self.country) \(self.area) \(self.locality) \(self.fare)"
                            self.Mylocation = String(format: "%@ %@ %@ %@ %@",place.country ?? "", place.administrativeArea ?? "", place.locality ?? "", place.thoroughfare ?? "", place.subThoroughfare ?? "")
                            self.setlocationfield.text = self.Mylocation
                        }else{
                            self.setlocationfield.text = "지역 이름을 불러오지 못하였습니다."
                        }
                    }else{
                        self.setlocationfield.text = "정확한 위치에 가주세요"
                    }
                }
            }
        }
    }

    @IBAction func currentLocation(_ sender: Any) {
        locationManager.startUpdatingLocation()
        searching = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if searching == true {
            locationManager.stopUpdatingLocation()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "EditInformation") {
            let navVc = segue.destination as! UINavigationController
            let vc = navVc.viewControllers.first as! EditRestaurant
            vc.getlat = self.mylat
            vc.getlon = self.mylon
        }
    }
}
