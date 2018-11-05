//
//  GraphContViewController.swift
//  FenceItApp_FIT5140
//
//  Created by Alfredo Zamudio on 3/11/18.
//  Copyright © 2018 Alfredo Zamudio. All rights reserved.
//

import UIKit
import SwiftChart
import Firebase
import FirebaseDatabase

class GraphContViewController: UIViewController, ChartDelegate {
    @IBOutlet weak var chart: Chart!
    @IBOutlet weak var chart2: Chart!
    var selectedChart = 0
    var databaseRef = DatabaseReference()
    var recordList: [Alert] = []
    var points: [Double] = []
    var labels: [Int] = []
    var points2: [Double] = []
    var labels2: [Int] = []
    
    override func viewDidLoad() {
        self.navigationItem.title = "Monthly Report"
        chart.delegate = self
        getStatisticsFromUser()
    }
    
    func getStatisticsFromUser(){
        databaseRef = Database.database().reference().child("alerts")
        var data = [(x:0,y:0.0)]
        var data2 = [(x:0,y:0.0)]
        databaseRef.observeSingleEvent(of: .value){ (snapshot) -> Void in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                self.recordList = []
                //iterating through all the values
                for lecture in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let record = lecture.value as? [String: Any] else { continue }
                    let date = record["date"] as? String
                    let day = self.getDay(date: date!)
                    let hour = self.getHour(date: date!)
                    let idSensor = record["id"] as? String
                    let sensorName = self.getNameOfSensor(idSensor: (idSensor)!)
                    let icon = "warning-1"
                    let alertRecord = Alert(date: String(date!), idSensor: (idSensor?.description)!, icon: icon, sensorName: sensorName, dateLong: 0)
                    
                    if self.labels.contains(day!){
                        let indx = self.labels.firstIndex(of:day!)
                        self.points[indx!] = self.points[indx!] + 1.0
                    } else {
                        self.labels.append(day!)
                        self.points.append(1.0)
                    }
                    
                    if self.labels2.contains(hour!){
                        let indx = self.labels2.firstIndex(of:hour!)
                        self.points2[indx!] = self.points2[indx!] + 1.0
                    } else {
                        self.labels2.append(hour!)
                        self.points2.append(1.0)
                    }
                }
                self.chart.xLabels = [0]
                
                for i in 0...self.labels.count-1{
                    data.append((x:self.labels[i],y:self.points[i]))
                    self.chart.xLabels?.append(Double(self.labels[i]))
                }
                
                for i in 0...self.labels2.count-1{
                    data2.append((x:self.labels2[i],y:self.points2[i]))
                    self.chart2.xLabels?.append(Double(self.labels2[i]))
                }
                
                let series = ChartSeries(data: data)
                series.area = true
                series.color = ChartColors.purpleColor()
                self.chart.xLabelsFormatter = {String(Int(round($1)))+" day"}
                self.chart.add(series)
                
                let series2 = ChartSeries(data: data2)
                series2.area = true
                series2.color = ChartColors.orangeColor()
                self.chart2.xLabelsFormatter = {String(Int(round($1)))+" hs"}
                self.chart2.add(series2)
            }
        }
    }
    
    func getDay(date:String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let dateOb = dateFormatter.date(from: date) // replace Date String
        
        let calendar = NSCalendar.current
        let component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateOb!)
        return component.day!;
    }
    
    func getHour(date:String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let dateOb = dateFormatter.date(from: date) // replace Date String
        
        let calendar = NSCalendar.current
        let component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateOb!)
        return component.hour!;
    }
    
    func getNameOfSensor(idSensor:String) -> String{
        if(idSensor == "1001"){
            return "Motion Sensor"
        }
        
        return "UltraSonic Sensor"
    }
    
    // Chart delegate
    
    func didTouchChart(_ chart: Chart, indexes: Array<Int?>, x: Double, left: CGFloat) {
        for (seriesIndex, dataIndex) in indexes.enumerated() {
            if dataIndex != nil {
                // The series at `seriesIndex` is that which has been touched
                let value = chart.valueForSeries(seriesIndex, atIndex: dataIndex)
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        // Redraw chart on rotation
        chart.setNeedsDisplay()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        do{
            try Auth.auth().signOut()
            
        }catch{
            
        }
        self.dismiss(animated: true, completion: nil)
    }
}
