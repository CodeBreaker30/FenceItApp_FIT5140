//
//  AlertViewController.swift
//  FenceItApp_FIT5140
//
//  Created by Alfredo Zamudio on 1/11/18.
//  Copyright © 2018 Alfredo Zamudio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AlertViewController: UITableViewController {
    var databaseRef = DatabaseReference()
    var getColorBase: String = ""
    var recordList: [Alert] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        observeRecords();
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return recordList.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "AlertCell",for: indexPath)
        let record: Alert = recordList[indexPath.row]//self.speciesList[indexPath.row]
        let image : UIImage = UIImage(named: record.icon)!
        cell.textLabel!.text = record.dateTime;
        //https://stackoverflow.com/questions/37518214/how-to-change-the-color-of-text-in-a-tableview-swift
        
        cell.detailTextLabel?.textColor = UIColor.red
        
        cell.detailTextLabel!.text = record.idSensor
        //record.dateTime! + " -- " +
        cell.imageView!.image = image
        
        return cell
    }
    
    //Create the obserser to check when a new row arrives.
    func observeRecords() {
        databaseRef = Database.database().reference().child("alerts")
        databaseRef.observe(DataEventType.value, with: { (snapshot) -> Void in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                self.recordList = []
                //iterating through all the values
                for lecture in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let record = lecture.value as? [String: Any] else { continue }
                    let date = record["date"] as? String
                    let idSensor = record["id"] as? String
                    let sensorName = self.getNameOfSensor(idSensor: idSensor!)
                    let icon = "warning-1"
                    let alertRecord = Alert(date: String(date!), idSensor: idSensor!, icon: icon, sensorName: sensorName)
                    
                    self.recordList.append(alertRecord)
                    //print("New \(self.getColorBase) record detected!")
                    }
                //self.orderDsc()
            }
        })
    }
    
    //Ordering descendant
    func orderDsc(){
        /*if recordList.count > 1 {
            recordList = recordList.sorted(by: { $0.dateTime > $1.dateTime })
            tableView.reloadData()
        }*/
    }
    
    func showOkMessage(){
        if recordList.count < 1 {
            let alertRecord = Alert(date: "No alerts, you are safe!!", idSensor: "", icon: "checked", sensorName: "No issues at home!!")
            self.recordList.append(alertRecord)
        }
    }
    
    func getNameOfSensor(idSensor:String) -> String{
        if(idSensor == "1001"){
            return "Motion Sensor"
        }
        
        return "UltraSonic Sensor"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let pass = story.instantiateViewController(withIdentifier: "DetailAlertController") as! DetailAlertController
        
        let fDetail = self.recordList[indexPath.row]
        pass.getSensorId = fDetail.idSensor
        pass.getSensorName = fDetail.sensorName
        pass.getDate = transformDate(dateIn: Int(fDetail.dateTime!)!)
        self.navigationController?.pushViewController(pass, animated: true)
    }
    
    func transformDate(dateIn: Int) -> String {
        //Convert to Date
        let date = NSDate(timeIntervalSince1970: TimeInterval(dateIn/1000))
        
        //Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm:a"
        dateFormatter.timeZone = NSTimeZone(name: "GMT+10")! as TimeZone
        let dateString = dateFormatter.string(from: date as Date)
        //print("formatted date is =  \(dateString)")
        return dateString
    }
}
