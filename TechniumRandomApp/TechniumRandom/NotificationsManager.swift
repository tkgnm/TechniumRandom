//
//  NotificationsManager.swift
//  TechniumRandom
//
//  Created by Thomas King on 09/09/2022.
//

import Foundation
import UserNotifications


enum DayOfWeek: String, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

enum TimeUnit: String, Codable {
    case daily, weekly
}

class NotificationsManager: ObservableObject {

    // MARK: Notification settings

    let timeUnits: [TimeUnit]

    let daysOfWeek: [DayOfWeek]
    let center: UNUserNotificationCenter

    @Published var notificationsDisabled: Bool

    @Published var frequency: TimeUnit = .daily
    @Published var dayOfWeek: DayOfWeek = .monday
    @Published var notificationTime: Date = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? .now


    init() {

        //        tries to load notification settings if present
        if let data = UserDefaults.standard.data(forKey: "notification") {

            let decoder = JSONDecoder()
            do {
                if let notification = try decoder.decode(Notification?.self, from: data) {
                    self.notificationTime = notification.notificationTime
                    self.frequency = notification.frequency
                    self.dayOfWeek = notification.dayOfWeek
                }
            } catch {
                print(error.localizedDescription)

                //              else, sets defaults
                self.frequency = .daily
                self.dayOfWeek = .monday
                self.notificationTime = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? .now
            }
        }

        self.timeUnits = [.daily, .weekly]
        self.daysOfWeek = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        self.center = UNUserNotificationCenter.current()
        self.notificationsDisabled = false

        //        logic to check if notifications are enabled and if not disables the form
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .denied:
                    self.notificationsDisabled = true
                default:
                    //                    can only be performed ONCE, on the first time the app is opened
                    self.requestAuthorisation()
            }
        }
    }

    func saveDate() {
        let savedNotification = Notification(notificationTime: notificationTime, frequency: frequency, dayOfWeek: dayOfWeek)

        do {
            print (savedNotification)
            let encoder = JSONEncoder()
            let data = try encoder.encode(savedNotification)
            UserDefaults.standard.set(data, forKey: "notification")
        } catch {
            print(error.localizedDescription)
        }

    }


    // MARK: Notification center

    func requestAuthorisation() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if let error = error {
                print (error.localizedDescription)
            }
            //            self.checkAuthorisationStatus()
            if granted {
                self.notificationsDisabled = false
            }
        }
    }

    func checkAuthorisationStatus()  {
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .denied:
                    self.notificationsDisabled = true
                default:
                    self.notificationsDisabled = false
            }
        }
    }


    func cancelNotifications() {
        //        code to come
        print("cancel notifications called")
    }

    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Kev sez..."
        content.subtitle = "Swipe for a bit of advice"
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        var dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: notificationTime)

        if frequency == .weekly {
            dateComponents.weekday = (daysOfWeek.firstIndex(of: dayOfWeek) ?? 0) + 2
        } else {
            dateComponents.weekday = .none
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: "kevID", content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)

//    preserves UI
        saveDate()
    }
}
