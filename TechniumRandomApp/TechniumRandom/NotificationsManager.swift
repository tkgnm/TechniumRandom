//
//  NotificationsManager.swift
//  TechniumRandom
//
//  Created by Thomas King on 09/09/2022.
//

import Foundation
import UserNotifications

class NotificationsManager: ObservableObject {

    enum TimeUnit: String {
        case daily, weekly
    }

    let timeUnits: [TimeUnit] = [.daily, .weekly]

    enum DayOfWeek: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }

    let daysOfWeek: [DayOfWeek] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]

    @Published var notificationsEnabled = false
    @Published var frequency: TimeUnit = .daily
    @Published var dayOfWeek: DayOfWeek = .monday
    @Published var notificationTime = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? .now

    func requestAuthorization() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { success, error  in
            if success {
                print ("all set")
                self.addNotification(for: "my advice")
            } else if let error = error {
                print(error.localizedDescription)
            }
          // TODO: Fetch notification settings
        }
    }

    func addNotification(for advice: String) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Some advie for you today"
            content.subtitle = "Live long and prosper"
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)


            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                self.requestAuthorization()
            }
        }
    }
}
