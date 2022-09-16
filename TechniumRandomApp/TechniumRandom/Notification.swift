//
//  Notification.swift
//  TechniumRandom
//
//  Created by Thomas King on 16/09/2022.
//

import Foundation

struct Notification: Codable {

    var notificationTime: Date
    var frequency: TimeUnit
    var dayOfWeek: DayOfWeek
    
}
