//
//  User.swift
//  Traffic
//
//  Created by 김민국 on 2017. 7. 3..
//  Copyright © 2017년 김민국. All rights reserved.
//


class Userdata {

    var myname: String?
    var myaddress: String?
    var myaccount: String?
    var mylatitude: Double?
    var mylongitude: Double?
    var mycategory: String?
    var mynow: String?
    
    init(name: String?, address: String?, account: String?, latitude: Double?, longitude: Double?, category: String?, now: String?) {
        myname = name
        myaddress = address
        myaccount = account
        mylatitude = latitude
        mylongitude = longitude
        mycategory = category
        mynow = now
    }
}
