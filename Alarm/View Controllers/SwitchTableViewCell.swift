//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Taylor Bills on 1/29/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

// MARK: -  Delegate Protocol

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

// MARK: -  Class

class SwitchTableViewCell: UITableViewCell {
    
    // MARK: -  Properties
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    // MARK: -  Actions
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        if let delegate = delegate {
            delegate.switchCellSwitchValueChanged(cell: self)
        }
    }
    
    // MARK: -  Update Views
    
    func updateViews() {
        guard let alarm = alarm else { return }
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
    }
}
