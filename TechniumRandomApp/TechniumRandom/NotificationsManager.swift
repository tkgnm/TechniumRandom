//
//  NotificationsManager.swift
//  TechniumRandom
//
//  Created by Thomas King on 09/09/2022.
//

import Foundation
import UserNotifications
import UIKit

class NotificationsManager: ObservableObject {

    //    MARK: Class properties

    let center = UNUserNotificationCenter.current()

    //    users can pick from these options in SettingsView
    let timeUnits: [TimeUnit] = [.daily, .weekly]
    let daysOfWeek: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]

    //   this variable reflects whether notifications are allowed via notification centre
    @Published var notificationsDenied = false

    //  this variable reflects whether the user has enabled notifications in the app
    @Published var notificationsEnabled = false {
        willSet {
            if newValue != notificationsEnabled {
                if newValue == true {
                    requestAuthorisation()
                    scheduleNotification()
                } else {
                    cancelNotifications()
                }
            }
        }
    }

    //    a custom type encompassing the time, whether daily/weekly and (if weekly) the day of the week
    @Published var notification = Notification(notificationTime: Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? .now, frequency: .daily, dayOfWeek: .monday) {
        didSet {
            scheduleNotification()
        }
    }

    //    MARK: Class initialiser

    init() {
        //      checks to see if the user already has notification settings saved
        if let savedNotification = UserDefaults.standard.object(forKey: "notification") as? Data {
            let decoder = JSONDecoder()
            if let loadedNotification = try? decoder.decode(Notification.self, from: savedNotification) {
                self.notification = Notification(notificationTime: loadedNotification.notificationTime, frequency: loadedNotification.frequency, dayOfWeek: loadedNotification.dayOfWeek)
            }
        }
    }

    //    MARK: Class methods

    private func saveDate() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(notification)
            UserDefaults.standard.set(data, forKey: "notification")
        } catch {
            print(error.localizedDescription)
        }
    }

    //    a function that updates the UI based on whether the user has granted notifications or not
    func checkAuthorisationStatus()  {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                    case .denied:
                        self.notificationsDenied = true
                        self.notificationsEnabled  = false
                    default:
                        self.notificationsDenied = false
                        self.evaluateNotifications()
                }
            }
        }
    }

    func evaluateNotifications() {
        center.getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.notificationsEnabled = requests.count > 0 ? true : false
            }
        }
    }

    func showAppSystemSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings)
        }
    }

    func isNotificationTimeUpToDate() -> Bool {
        if let savedNotification = UserDefaults.standard.object(forKey: "notification") as? Data {
            let decoder = JSONDecoder()
            if let loadedNotification = try? decoder.decode(Notification.self, from: savedNotification) {
                if notification == loadedNotification {
                    return false
                } else {
                    return true
                }
            }
        }
        return true
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
                    self.scheduleNotification()
                }
            }
        }
    }

    func scheduleNotification() {
        var dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: notification.notificationTime)
        if notification.frequency == .weekly {
            dateComponents.weekday = (daysOfWeek.firstIndex(of: notification.dayOfWeek) ?? 0) + 2
        } else {
            dateComponents.weekday = .none
        }

        let content = createNotificationContent()
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: "kevID", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        //    preserves UI
        saveDate()
        evaluateNotifications()
    }

    func scheduleTestNotification() {
        let content = createNotificationContent()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: "kevID", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)

        //    preserves UI
        saveDate()
    }

    func createNotificationContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Kev has a bit of advice"
        content.subtitle = "... open for some fresh wisdom"
        content.sound = UNNotificationSound.default
        return content
    }

    private func cancelNotifications() {
        center.removeAllPendingNotificationRequests()
    }
}
