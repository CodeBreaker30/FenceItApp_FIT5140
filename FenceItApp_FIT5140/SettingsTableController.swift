//
//  SettingsTableController.swift
//  FenceItApp_FIT5140
//
//  Created by Alfredo Zamudio on 2/11/18.
//  Copyright © 2018 Alfredo Zamudio. All rights reserved.
//

import UIKit

class SettingsTableController: UITableViewController, SwitchTableViewCellDelegate {

    let section = ["App Settings"]
    
    let items = [["Push Notifications"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
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
        // #warning Incomplete implementation, return the number of rows
        return items[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath as IndexPath) as! SwitchTableViewCell
        //let image : UIImage = UIImage(named: "011-Settings")!
        // Configure the cell...
        
        cell.headerText.text = items[indexPath.section][indexPath.row]
        //cell.imageCell.image = image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    /*override func tableView(_ tableView: UITableView, heightForRowAt: indexPath as IndexPath) -> CGFloat {
        return 70
    }*/
    
    func didTappedSwitchInCell(cell: SwitchTableViewCell, isSwitchOn: Bool) {
        if cell.headerText.text == "Push Notifications" && isSwitchOn {
            /*Background Notifications*/
        }
    }
}
