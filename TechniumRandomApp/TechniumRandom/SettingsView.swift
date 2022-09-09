//
//  SettingsView.swift
//  TechniumRandom
//
//  Created by Thomas King on 08/09/2022.
//

import SwiftUI

struct SettingsView: View {

    @StateObject var notificationsManager = NotificationsManager()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Turn notifications on", isOn: $notificationsManager.notificationsEnabled.animation())

                    if notificationsManager.notificationsEnabled {

                        Picker("What frequency", selection: $notificationsManager.frequency.animation()) {
                            ForEach(notificationsManager.timeUnits, id: \.self) { unit in
                                Text(unit.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(.segmented)

                        if notificationsManager.frequency == .weekly {
                            Picker("What day", selection: $notificationsManager.dayOfWeek) {
                                ForEach(notificationsManager.daysOfWeek, id: \.self) { day in
                                    Text(day.rawValue.capitalized)
                                }
                            }
                        }

                        DatePicker("What time", selection: $notificationsManager.notificationTime.animation(), displayedComponents: .hourAndMinute)
                    }

                } header: {
                    Text("Notifications")
                }
            }
            .onChange(of: notificationsManager.notificationsEnabled) { _ in
                notificationsManager.requestAuthorization()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
