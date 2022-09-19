//
//  NotificationDelegate.swift
//  TechniumRandom
//
//  Created by Thomas King on 19/09/2022.
//

import Foundation
import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {

        let userInfo = response.notification.request.content.userInfo
        print (userInfo)
        print("Exiting function")
    }

}
