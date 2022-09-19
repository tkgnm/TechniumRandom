//
//  TechniumRandomApp.swift
//  TechniumRandom
//
//  Created by Thomas King on 06/09/2022.
//

import SwiftUI

@main
struct TechniumRandomApp: App {

    private var delegate: NotificationDelegate = NotificationDelegate()

    init() {
        let center = UNUserNotificationCenter.current()
        center.delegate = delegate
        
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
