//
//  NotificationsManager.swift
//  TechniumRandom
//
//  Created by Thomas King on 09/09/2022.
//

import Foundation
import UserNotifications

class NotificationsManager: ObservableObject {

    // MARK: Notification settings

    enum TimeUnit: String {
        case daily, weekly
    }

    let timeUnits: [TimeUnit]

    enum DayOfWeek: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }

    let daysOfWeek: [DayOfWeek]
    let center: UNUserNotificationCenter

    @Published var notificationsDisabled: Bool
    @Published var frequency: TimeUnit
    @Published var dayOfWeek: DayOfWeek
    @Published var notificationTime: Date

    init() {

        self.frequency = .daily
        self.dayOfWeek = .monday
        self.notificationTime = Calendar.current.date(bySettingHour: 10, minute: 30, second: 0, of: Date()) ?? .now
        self.timeUnits = [.daily, .weekly]
        self.daysOfWeek = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        self.center = UNUserNotificationCenter.current()
        self.notificationsDisabled = false

        center.getNotificationSettings { settings in

            switch settings.authorizationStatus {
                case .denied:
                    self.notificationsDisabled = true
                default:
                    self.requestAuthorisation()
//                    self.notificationsDisabled = false
            }
        }
    }

    func checkAuthorisationStatus()  {
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                case .denied:
                    self.notificationsDisabled = true
                default:
                    self.requestAuthorisation()
//                    self.notificationsDisabled = false
            }
        }
    }

    // MARK: Notification center


    func requestAuthorisation() {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

            if let error = error {
                print (error.localizedDescription)
            }
            if granted {
                self.notificationsDisabled = false
            } else {
                self.notificationsDisabled = true
            }
        }
    }

    func cancelNotifications() {
//        code to come
        print("cancel notifications called")
    }
}