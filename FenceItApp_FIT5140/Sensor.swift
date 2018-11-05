//
//  Sensors.swift
//  FenceItApp_FIT5140
//
//  Created by Alfredo Zamudio on 4/11/18.
//  Copyright © 2018 Alfredo Zamudio. All rights reserved.
//

import Foundation

public class Sensor {
    
public var macid: String?
public var feature: String
public var description: String
public var user : String
public var notify: Bool

init(macid:String?,feature:String,description:String,user:String,notify:Bool){
    self.macid = macid
    self.feature = feature
    self.description = description
    self.user = user
    self.notify = notify
}
    
}
