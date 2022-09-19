//
//  NotificationDelegate.swift
//  TechniumRandom
//
//  Created by Thomas King on 19/09/2022.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        TabController.shared.open(.advice)
        completionHandler()
    }
}
