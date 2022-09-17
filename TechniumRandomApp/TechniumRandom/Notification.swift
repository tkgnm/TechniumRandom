//
//  Notification.swift
//  TechniumRandom
//
//  Created by Thomas King on 16/09/2022.
//

import Foundation

enum DayOfWeek: String, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

enum TimeUnit: String, Codable {
    case daily, weekly
}

struct Notification: Codable {

    var notificationTime: Date
    var frequency: TimeUnit
    var dayOfWeek: DayOfWeek
    
}
