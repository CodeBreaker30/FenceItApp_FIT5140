//
//  SwitchTableViewCell.swift
//  FenceItApp_FIT5140
//
//  Created by Alfredo Zamudio on 2/11/18.
//  Copyright © 2018 Alfredo Zamudio. All rights reserved.
//

import UIKit
protocol SwitchTableViewCellDelegate{
    func didTappedSwitchInCell(cell: SwitchTableViewCell, isSwitchOn: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var settingOn: UISwitch!
    @IBOutlet weak var imageCell: UIImageView!
    
    @IBAction func switchValueChanged(_ sender: Any) {
        
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
