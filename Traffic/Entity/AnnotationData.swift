//
//  AnnotationData.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 25..
//  Copyright © 2017년 김민국. All rights reserved.
//

import MapKit

class AnnotationData: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var ID: String
    var now: String

    
    init(name: String, account:String, coor:CLLocationCoordinate2D, nowtra:String) {
        self.coordinate = coor
        self.title = name
        self.ID = account
        self.now = nowtra
    }
}
