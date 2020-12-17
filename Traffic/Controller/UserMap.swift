//
//  Usermap.swift
//  Traffic
//
//  Created by 김민국 on 2017. 6. 25..
//  Copyright © 2017년 김민국. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import Firebase

class UserMap: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var ref: DatabaseReference!
    var databaseHandle:DatabaseHandle?
    
    var Annotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!

    var post = [String:AnyObject]()
    
    var getID:String = ""
    var now:String = ""
    var name:String = ""
    var mycat:String = ""
    
    let annotation = MKPointAnnotation()
    
    //---------------------------------
    
    var mylon:Double = 0.0
    var mylat:Double = 0.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "기본 바탕")!
        
        if let navigationController = self.navigationController {
            navigationController.navigationBar.setBackgroundImage(image, for: .default)
            navigationController.navigationBar.shadowImage = UIImage()
        }
        
        mapView.delegate=self
        
        ref = Database.database().reference()
        
        databaseHandle = ref.child("Users").child(mycat).child(getID).observe(.value, with: {(snapshot: DataSnapshot) in
            self.post = snapshot.value as! [String : AnyObject]
            self.now = self.post["now"] as? String ?? "쾌적"
            
            self.mapView.addAnnotation(self.annotation)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            self.mapView.selectAnnotation(self.annotation, animated: true)
        })

//------
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: mylat, longitude: mylon)
        annotation.coordinate = centerCoordinate
        annotation.title = name
 
        

    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//
//        let center = CLLocationCoordinate2D(latitude: mylat, longitude: mylon)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//
//        self.mapView.setRegion(region, animated: true)
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var mypinState = mapView.dequeueReusableAnnotationView(withIdentifier: "inform")
        
        if mypinState == nil{
            mypinState = MKAnnotationView(annotation: annotation, reuseIdentifier: "inform")
            
            mypinState!.canShowCallout=true
            
        }else{
            mypinState!.annotation = annotation;
        }
        
//        now = (annotation as! MyPointAnnotation).now
        
        //            if let annotationA = annotation as? MyPointAnnotation{
        
        if now == "혼잡"{
            //                pinView?.pinTintColor = UIColor.red
            //                pinView?.image = UIImage(named: "신호등빨강")
            mypinState?.image = UIImage(named: "신호등Red")
        }else if now == "원활"{
            //                pinView?.pinTintColor = UIColor.orange
            //                pinView?.image = UIImage(named: "신호등노랑")
            mypinState?.image = UIImage(named: "신호등Orange")
        }else if now == "쾌적"{
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
        //------------------
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "Inform") as? MKPinAnnotationView
//
//        if pinView == nil{
//            pinView=MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "Inform")
//
//            pinView!.canShowCallout=true
//
//        }else{
//            pinView!.annotation = annotation;
//        }
//
//        if now == "혼잡"{
//            pinView?.pinTintColor = UIColor.red
//        }else if now == "원활"{
//            pinView?.pinTintColor = UIColor.orange
//        }else if now == "쾌적"{
//            pinView?.pinTintColor = UIColor.green
//        }else{
//
//        }
//
//        let btn = UIButton(type:.infoDark) as UIButton
//        pinView!.rightCalloutAccessoryView = btn
//
//        return pinView;
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "Information", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "Information") {
            let navVc = segue.destination as! UITabBarController
            let tagVc = navVc.viewControllers?.first as! UINavigationController
            let vc = tagVc.viewControllers.first as! GetTrafficForUser
            vc.ID = self.getID
        }
    }
    @IBAction func ReNew(_ sender: Any) {
        mapView.removeAnnotation(annotation)
        
        databaseHandle = ref.child("Users").child(mycat).child(getID).observe(.value, with: {(snapshot: DataSnapshot) in
            self.post = snapshot.value as! [String : AnyObject]
            self.now = self.post["now"] as? String ?? "쾌적"
            
            self.mapView.addAnnotation(self.annotation)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            self.mapView.selectAnnotation(self.annotation, animated: true)
        })
    }
    @IBAction func GoBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
