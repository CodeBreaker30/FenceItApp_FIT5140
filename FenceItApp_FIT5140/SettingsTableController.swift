//
//  SettingsTableController.swift
//  FenceItApp_FIT5140
//
//  Created by Alfredo Zamudio on 2/11/18.
//  Copyright © 2018 Alfredo Zamudio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SettingsTableController: UITableViewController, SwitchTableViewCellDelegate {
    var databaseRef = DatabaseReference()
    let section = ["App Settings"]
    var sensorsList :[Sensor] = []
    var itemsSectionApp = ["Push Notifications"]
    var currentUser = ""
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        handle = Auth.auth().addStateDidChangeListener(
            {auth, user in
                if user != nil {
                    self.currentUser = user!.email!
                    self.getSensorsByUser()
                }
        })

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return section.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return sensorsList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath as IndexPath) as! SwitchTableViewCell
        //let image : UIImage = UIImage(named: "011-Settings")!
        // Configure the cell...
        let record: Sensor = sensorsList[indexPath.row]
        cell.headerText.text = record.feature
        cell.subtitleText.text = record.macid!
        cell.settingOn.isOn = record.notify
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func didTappedSwitchInCell(cell: SwitchTableViewCell, isSwitchOn: Bool) {
        if cell.headerText.text == "Push Notifications" && isSwitchOn {
            /*Background Notifications*/
        }
    }
    
    func getSensorsByUser(){
        databaseRef = Database.database().reference().child("sensors")
        var data = [(x:0,y:0.0)]
        databaseRef.observeSingleEvent(of: .value){ (snapshot) -> Void in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //iterating through all the values
                for lecture in snapshot.children.allObjects as! [DataSnapshot] {
                    guard let record = lecture.value as? [String: Any] else { continue }
                    let macid = record["macid"] as? String
                    let feature = record["feature"] as? String
                    let description = record["description"] as? String
                    let user = record["users"] as? String
                    let notify = record["notify"] as? Bool
                    let icon = "adjust"
                    if(user == self.currentUser){
                        let sensorRecord = Sensor(macid: macid, feature: feature!, description: description!, user: user!, notify: notify!)
                            self.sensorsList.append(sensorRecord)
                    }
                }
                
                let sensorRecord = Sensor(macid: "", feature: "Push Notifications", description: "Enable notifications when app is not open", user: "", notify: true)
                self.sensorsList.append(sensorRecord)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /*do{
            try Auth.auth().signOut()
            
        }catch{
            
        }*/
        self.dismiss(animated: true, completion: nil)
    }
}
