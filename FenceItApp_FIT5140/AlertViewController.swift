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
import MessageUI

class AlertViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    var databaseRef = DatabaseReference()
    var getColorBase: String = ""
    var recordList: [Alert] = []
    var currentUser: String = ""
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Alerts"
        // Do any additional setup after loading the view.
        handle = Auth.auth().addStateDidChangeListener(
            {auth, user in
                if user != nil {
                    self.currentUser = user!.email!
                    
                }
        })
        self.observeRecords()
        
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
        let userId = Auth.auth().currentUser!.uid
        databaseRef = Database.database().reference().child("alerts")
        
        databaseRef.observe(DataEventType.value, with: { (snapshot) -> Void in
            //if the reference have some values
            self.currentUser = Auth.auth().currentUser!.email!
            if snapshot.childrenCount > 0 {
                self.recordList = []
                //iterating through all the values
                for lecture in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let record = lecture.value as? [String: Any] else { continue }
                    let date = record["date"] as? String
                    let idSensor = record["id"] as? String
                    let sensorName = self.getNameOfSensor(idSensor: (idSensor)!)
                    let icon = "warning-1"
                    let dateStamp = self.getTimeStamp(date: date!)
                    
                    let alertRecord = Alert(date: String(date!), idSensor: (idSensor)!, icon: icon, sensorName: sensorName, dateLong: Int64(dateStamp))
                    
                    self.recordList.append(alertRecord)
                    //print("New \(self.getColorBase) record detected!")
                    }
                if self.getMinutesDiff(date: self.recordList[0].dateTime!){
                    self.sendNotification(alert:self.recordList[0])
                }
                self.orderDsc()
                self.tableView.reloadData()
            } else {
                self.showOkMessage()
            }
        }
        )
        
    }
    
    func showOkMessage(){
        if recordList.count < 1 {
            let alertRecord = Alert(date: "No alerts, you are safe!!", idSensor: "", icon: "checked", sensorName: "No issues at home!!", dateLong: 0)
            self.recordList.append(alertRecord)
        }
    }
    
    //Ordering descendant
    func orderDsc(){
        if recordList.count > 1 {
            recordList = recordList.sorted(by: { $0.dateInt > $1.dateInt })
            tableView.reloadData()
        }
    }
    
    func getTimeStamp(date:String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let dateOb = dateFormatter.date(from: date)
        
        return Int(dateOb!.timeIntervalSince1970)
    }
    
    func getNameOfSensor(idSensor:String) -> String{
        
        return "UltraSonic Sensor"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let pass = story.instantiateViewController(withIdentifier: "DetailAlertController") as! DetailAlertController
        
        let fDetail = self.recordList[indexPath.row]
        pass.getSensorId = fDetail.idSensor
        pass.getSensorName = fDetail.sensorName
        pass.getDate = fDetail.dateTime!
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
    
    func sendEmail(alert:Alert) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["stratofortress.01@gmail.com"])//([self.currentUser])
            mail.setSubject("[URG]FenceItApp Alert: Home can be at Risk")
            mail.setMessageBody("<p>Issue detected at home at "+alert.dateTime!+" by sensor:"+alert.sensorName+"</p>", isHTML: true)
            DispatchQueue.main.async {
                self.present(mail,animated:true, completion: nil)
            }
        } else {
            // show failure alert
        }
        
    }
    
    func sendNotification(alert:Alert){
        let body = "Issue detected at home at "+alert.dateTime!+" by sensor:"+alert.sensorName
        let subject = "[URG]FenceItApp Alert: Home can be at Risk"
        var request = URLRequest(url: URL(string: "http://localhost:8080/api/Authentication/SendMailFenceItApp?recip="+self.currentUser+"&subject="+subject+"&body="+body)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: "", options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response,error -> Void in
            print(response!)
        })
        
        task.resume()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func getMinutesDiff(date:String) -> Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let dateOb = dateFormatter.date(from: date)
        
        let calendar = NSCalendar.current as NSCalendar
        let currentDate = Date()
        let d1 = calendar.startOfDay(for: dateOb!)
        let d2 = calendar.startOfDay(for: currentDate)
        let flags = NSCalendar.Unit.minute
        let components = calendar.components(flags, from: d1, to: d2)
        return (components.minute!<2);
    }
    
    func getDay(date:String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let dateOb = dateFormatter.date(from: date) // replace Date String
        
        let calendar = Calendar.current
        let component = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateOb!)
        return component.day!;
    }
}
