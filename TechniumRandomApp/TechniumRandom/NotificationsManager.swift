//
//  NotificationsManager.swift
//  TechniumRandom
//
//  Created by Thomas King on 09/09/2022.
//

import Foundation
import UserNotifications

class NotificationsManager: ObservableObject {

    let center = UNUserNotificationCenter.current()

//    users can pick from these options in SettingsView
    let timeUnits: [TimeUnit] = [.daily, .weekly]
    let daysOfWeek: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]

//   notifications are enabled by default but may change once the class has been initialised
//   this variable is responsible for saying whether notification alerts were declined by the user
    @Published var notificationsDenied = false

//  this variable allows the user to enable/disable notifications via the app, not the system
    @Published var notificationsEnabled = false {
        willSet {
            if newValue == true {
                requestAuthorisation()
            } else {
                cancelNotifications()
            }
        }
    }

//    a custom type encompassing the time, whether daily/weekly and (if weekly) the day of the week
    @Published var notification = Notification(notificationTime: Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? .now, frequency: .daily, dayOfWeek: .monday) {
        didSet {
            if let savedNotification = UserDefaults.standard.object(forKey: "notification") as? Data {
                let decoder = JSONDecoder()
                if let loadedNotification = try? decoder.decode(Notification.self, from: savedNotification) {
                    if notification == loadedNotification {
                        notificationNeedsUpdating = false
                    } else {
                        notificationNeedsUpdating = true
                    }
                }
            }
            notificationNeedsUpdating = true
        }
    }

    @Published var notificationNeedsUpdating = false


    init() {

//      checks to see if the user already has notification settings saved
        if let savedNotification = UserDefaults.standard.object(forKey: "notification") as? Data {
            let decoder = JSONDecoder()
            if let loadedNotification = try? decoder.decode(Notification.self, from: savedNotification) {
                self.notification = Notification(notificationTime: loadedNotification.notificationTime, frequency: loadedNotification.frequency, dayOfWeek: loadedNotification.dayOfWeek)
            }
        }
//        self.requestAuthorisation()

    }

    func saveDate() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(notification)
            UserDefaults.standard.set(data, forKey: "notification")
        } catch {
            print(error.localizedDescription)
        }
    }

    //    a function that updates the UI based on whether the user has granted notificatins or not
    func checkAuthorisationStatus()  {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                    case .denied:
                        self.notificationsDenied = true
                        self.notificationsEnabled  = false
                    default:
                        self.notificationsDenied = false
                }
            }
        }
    }
    
    func cancelNotifications() {
        center.removePendingNotificationRequests(withIdentifiers: ["kevID"])
    }
    // MARK: Notification center

    func requestAuthorisation() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print (error.localizedDescription)
            }
            if granted {
                DispatchQueue.main.async {
                    self.notificationsDenied = false
                }
            }
        }
    }


    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Kev has a bit of advice"
        content.subtitle = "... open for some fresh wisdom"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        var dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: notification.notificationTime)

        if notification.frequency == .weekly {
            dateComponents.weekday = (daysOfWeek.firstIndex(of: notification.dayOfWeek) ?? 0) + 2
        } else {
            dateComponents.weekday = .none
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "kevID", content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)

        //    preserves UI
        saveDate()
        notificationNeedsUpdating = false
    }
}
