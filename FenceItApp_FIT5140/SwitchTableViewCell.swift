//
//  SwitchTableViewCell.swift
//  FenceItApp_FIT5140
//
//  Created by Alfredo Zamudio on 2/11/18.
//  Copyright © 2018 Alfredo Zamudio. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol SwitchTableViewCellDelegate{
    func didTappedSwitchInCell(cell: SwitchTableViewCell, isSwitchOn: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var settingOn: UISwitch!
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var subtitleText: UILabel!
    var databaseRef = DatabaseReference()
    
    //Validates when a switch button changes its value
    @IBAction func switchValueChanged(_ sender: Any) {
        
        if headerText.text == "Push Notifications" {
                return
        }
        if headerText.text == "PIR Motion Sensor"{
        var sensorRef = databaseRef.child("sensors")
            Database.database().reference().child("sensors").child("0").updateChildValues(["notify":self.settingOn.isOn])
        }
        
        if headerText.text == "Ultra Sonic Sensor"{
            var sensorRef = databaseRef.child("sensors")
            Database.database().reference().child("sensors").child("1").setValue(["notify":self.settingOn.isOn])
        }
        /*var handle = sensorRef.child("macid").observe(.value, with: { (snapshot) in
            
            if let value = snapshot.value as? String{
                
                if snapshot.value as? String == self.subtitleText.text {
                    sensorRef.child("notify").setValue(self.settingOn.isOn)
                }
            }
        })*/
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
