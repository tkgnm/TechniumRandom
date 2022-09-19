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

        let userInfo = response.notification.request.content.userInfo
        print (userInfo)

//        AdviceManager.shared.randomTechnium()
        TabController.shared.open(.advice)
        
        print("Exiting function")
    }
}
