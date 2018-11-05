//
//  DetailAlertController.swift
//  FenceItApp_FIT5140
//
//  Created by Alfredo Zamudio on 1/11/18.
//  Copyright © 2018 Alfredo Zamudio. All rights reserved.
//

import UIKit

class DetailAlertController: UIViewController {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelSensor: UILabel!
    var getSensorName:String = ""
    var getSensorId:String = ""
    var getDate:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelDate.text = getDate
        labelSensor.text = getSensorName + " - " + getSensorId
        // Variables were gotten from previous controller
    }
    
    //Calls to triple 0 when hitted
    @IBAction func CallEmergency(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "tel://000") as! URL)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
