//
//  AlarmController.swift
//  Alarm
//
//  Created by Taylor Bills on 1/29/18.
//  Copyright © 2018 Taylor Bills. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {

    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Alarm Going Off!!!"
        content.body = alarm.name
        content.sound = UNNotificationSound.default()
        guard let fireDate = alarm.fireDate else { return }
        let alarmDateComponents = Calendar.current.dateComponents([.hour, .minute], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: alarmDateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            guard let error = error else { return }
            print(error.localizedDescription)
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}

class AlarmController {
    
    // MARK: -  Properties
    
    static var shared = AlarmController()
    var alarms: [Alarm] = []
    var mockAlarms: [Alarm] {
        get {
            let alarm1 = Alarm(fireTimeFromMidnight: 55, name: "alarm1")
            let alarm2 = Alarm(fireTimeFromMidnight: 125, name: "alarm2")
            let alarm3 = Alarm(fireTimeFromMidnight: 71, name: "alarm3")
            return [alarm1, alarm2, alarm3]
        }
    }
    
    // MARK: -  Initializers
    
    init() {
        self.alarms = self.mockAlarms
    }
    // MARK: -  Create
    
    // add new alarm
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) {
        let alarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(alarm)
    }
    
    // MARK: -  Read
    
    //Save Location
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "alarms.json"
        let url = documentDirectory.appendingPathComponent(fileName)
        return url
    }
    
    // Save Files
    func saveToPersistence() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(alarms)
            try data.write(to: fileURL())
        } catch let error {
            print("Error saving to disk: \(error.localizedDescription)")
        }
    }
    
    // Load Files
    func loadFromPersistentStorage() -> [Alarm] {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let alarms = try jsonDecoder.decode([Alarm].self, from: data)
            return alarms
        } catch let error {
            print("Error loading from disk \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: -  Update
    
    // Update existing alarm
    func updateExisting(alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String) {
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
    }
    
    // Toggle Switch
    func toggleEnabled(for alarm: Alarm) {
        if alarm.enabled {
        alarm.enabled = false
        } else {
            alarm.enabled = true
        }
    }
    
    // MARK: -  Delete
    
    // Delete existing alarm
    func deleteExisting(alarm: Alarm) {
        guard let index = alarms.index(of: alarm) else { return }
        alarms.remove(at: index)
    }
}
