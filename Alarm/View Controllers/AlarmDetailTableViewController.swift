//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Taylor Bills on 1/29/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController, AlarmScheduler {
    
    // MARK: -  Properties
    
    var alarm: Alarm? {
        didSet {
            if isViewLoaded {
            updateViews()
            }
        }
    }
    
    @IBOutlet weak var alarmPicker: UIDatePicker!
    @IBOutlet weak var alarmTextField: UITextField!
    @IBOutlet weak var alarmToggleButton: UIButton!
    
    // MARK: -  Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: -  Actions
    
    // alarm toggle on/off
    @IBAction func alarmToggleButtonTapped(_ sender: Any) {
        guard let alarm = alarm else { return }
        AlarmController.shared.toggleEnabled(for: alarm)
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        updateViews()
    }
    
    // save alarm
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let newAlarmName = alarmTextField.text else { return }
        guard let dateHelper = DateHelper.thisMorningAtMidnight else { return }
        let timeFromMidnight = alarmPicker.date.timeIntervalSince(dateHelper)
        guard let alarm = alarm else { return }
        if AlarmController.shared.alarms.contains(alarm) {
            AlarmController.shared.updateExisting(alarm: alarm, fireTimeFromMidnight: timeFromMidnight, name: newAlarmName)
            cancelUserNotifications(for: alarm)
            scheduleUserNotifications(for: alarm)
        } else {
            AlarmController.shared.addAlarm(fireTimeFromMidnight: timeFromMidnight, name: newAlarmName)
            scheduleUserNotifications(for: alarm)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -  UpdateViews
    private func updateViews() {
        if let alarm = alarm {
            guard let fireDate = alarm.fireDate else { return }
            alarmPicker.date = fireDate
            alarmTextField.text = alarm.name
            if alarm.enabled {
                alarmToggleButton.setTitleColor(UIColor.red, for: .normal)
                alarmToggleButton.setTitle("Disable", for: .normal)
            } else {
                alarmToggleButton.setTitleColor(.green, for: .normal)
                alarmToggleButton.setTitle("Enable", for: .normal)
            }
        } else {
            alarmToggleButton.isHidden = true
        }
    }
}
