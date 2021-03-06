//
//  Alert.swift
//  FenceItApp_FIT5140
//
//  Created by Alfredo Zamudio on 1/11/18.
//  Copyright © 2018 Alfredo Zamudio. All rights reserved.
//

import Foundation

public class Alert {
    
    public var dateTime: String?
    public var idSensor: String
    public var icon: String
    public var sensorName : String
    public var dateInt: Int64
    
    init(date:String?,idSensor:String,icon:String,sensorName:String,dateLong:Int64){
        self.dateTime = date
        self.idSensor = idSensor
        self.icon = icon
        self.sensorName = sensorName
        self.dateInt = dateLong
    }
    
}
