//
//  UserHomeLocationViewController.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 19..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol dataSentDelegate {
    func sendLocation(data: String)
}

class UserHomeLocationViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var newindicator: UIActivityIndicatorView!

    @IBOutlet weak var mylocationfield: UITextField!
    @IBOutlet weak var setlocationfield: UITextField!
    @IBOutlet weak var mapview: MKMapView!
    
    @IBOutlet weak var mapcenter: UIImageView!
    
    var locationManager = CLLocationManager()
    
    var loc = CLLocation()
    var Mylocation:String = ""
    
    var delegate:dataSentDelegate?
    
    var country:String = ""
    var area:String = ""
    var locality:String = ""
    var fare:String = ""
    
    override func viewDidLoad() {
        let image = UIImage(named: "기본 바탕")!
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(image, for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
            navigationController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        }
        
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(callMethod), for: .touchUpInside)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        imageView.image = UIImage(named: "back")
//        let label = UILabel(frame: CGRect(x: 35, y: 0, width: 50, height: 30))
//        label.text = "1234"
        let buttonView = UIView(frame: CGRect(x: 0, y: (navigationController?.navigationBar.frame.height)!/2, width: 90, height: 50))
        button.frame = buttonView.frame
        buttonView.addSubview(button)
        buttonView.addSubview(imageView)
//        buttonView.addSubview(label)
        let barButton = UIBarButtonItem.init(customView: buttonView)
        self.navigationItem.leftBarButtonItem = barButton
        
        //
        
    }
    
    @objc func callMethod() {
        if self.background.isHidden == true{
            delegate?.sendLocation(data: Mylocation)
            
            let defaults = UserDefaults.standard
            defaults.set(Mylocation, forKey: "myLocation")
            defaults.set(loc.coordinate.latitude, forKey: "myLatitude")
            defaults.set(loc.coordinate.longitude, forKey: "myLongitude")
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.mapview.delegate = self
        
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        
        self.newindicator.stopAnimating()
        self.newindicator.isHidden = true

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        loc = locationManager.location!
        
        CLGeocoder().reverseGeocodeLocation(loc) { (placemark, error) in
            if error != nil{
                print("there was error")
            }else{
                if let place = placemark?[0]{
//                    self.country = place.country!
//                    self.area = place.administrativeArea!
//                    self.locality = place.locality!
                    
//                    self.fare = place.thoroughfare!
                    
//                    self.Mylocation = "\(self.country) \(self.area) \(self.locality) \(self.fare)"
                    self.Mylocation = String(format: "%@ %@ %@ %@ %@",place.country ?? "", place.administrativeArea ?? "", place.locality ?? "", place.thoroughfare ?? "", place.subThoroughfare ?? "")
                    
                    self.mylocationfield.text = self.Mylocation
                }
            }
        }
        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(loc.coordinate, span)
        mapview.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
        if self.indicator.isAnimating == true && self.background.isHidden == false
        {
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.background.isHidden = true
        }else{
            print("isn't animating")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func goBack(_ sender: AnyObject) {
//        if self.background.isHidden == true{
//            delegate?.sendLocation(data: Mylocation)
//
//            let defaults = UserDefaults.standard
//            defaults.set(Mylocation, forKey: "myLocation")
//            defaults.set(loc.coordinate.latitude, forKey: "myLatitude")
//            defaults.set(loc.coordinate.longitude, forKey: "myLongitude")
//
//            dismiss(animated: true, completion: nil)
//        }
//    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

        if animated != true{
            let centerlat = mapview.centerCoordinate.latitude
            let centerlon = mapview.centerCoordinate.longitude
            
            let center = CLLocation(latitude: centerlat, longitude: centerlon)
            
            loc = center
            
            self.newindicator.isHidden = false
            self.newindicator.startAnimating()
            
            CLGeocoder().reverseGeocodeLocation(center) { (placemark, error) in
                if error != nil{
                    print("there was error")
                }else{
                    if let place = placemark?[0]{
                        
                        if place.country != nil && place.administrativeArea != nil && place.locality != nil && place.thoroughfare != nil{
                            self.country = (place.country)!
                            self.area = (place.administrativeArea)!
                            self.locality = (place.locality)!
                            self.fare = (place.thoroughfare)!
                            self.Mylocation = "\(self.country) \(self.area) \(self.locality) \(self.fare)"
                            
                            self.setlocationfield.text = self.Mylocation
                        }else{
                            self.setlocationfield.text = "위치 조정을 다시 해주세요"
                        }
                    }else{
                        self.setlocationfield.text = "정확한 위치에 가주세요"
                    }
                }
            }
            self.newindicator.stopAnimating()
            self.newindicator.isHidden = true
        }
    }
}
