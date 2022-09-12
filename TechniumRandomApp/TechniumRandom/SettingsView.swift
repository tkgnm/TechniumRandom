//
//  SettingsView.swift
//  TechniumRandom
//
//  Created by Thomas King on 08/09/2022.
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.scenePhase) private var scenePhase

    @StateObject var notificationsManager = NotificationsManager()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    if !notificationsManager.notificationsDisabled {
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
                    } else {
                        Text("You have disabled notifications. To change this, go to settings. ")
                    }

                    Button {
                        notificationsManager.scheduleNotification()
                    } label: {
                        Text("Update notifications")
                    }
                } header: {
                    Text("notifications")
                }
            }
        }
        .disabled(notificationsManager.notificationsDisabled)
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                notificationsManager.checkAuthorisationStatus()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
