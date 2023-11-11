//
//  MyBeacon.swift
//  Project22
//
//  Created by Yulian Gyuroff on 9.11.23.
//

import UIKit

class MyBeacon: NSObject {
    
    var uuid: String
    var major: NSNumber
    var minor: NSNumber
    
    init(uuid: String, major: NSNumber, minor: NSNumber) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }

}
