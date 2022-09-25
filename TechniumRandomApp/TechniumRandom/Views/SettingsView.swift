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
                        Picker("What frequency", selection: $notificationsManager.notification.frequency.animation()) {
                            ForEach(notificationsManager.timeUnits, id: \.self) { unit in
                                Text(unit.rawValue.capitalized)
                            }
                        }
                        .pickerStyle(.segmented)

                        if notificationsManager.notification.frequency == .weekly {
                            Picker("What day", selection: $notificationsManager.notification.dayOfWeek) {
                                ForEach(notificationsManager.daysOfWeek, id: \.self) { day in
                                    Text(day.rawValue.capitalized)
                                }
                            }
                        }

                        DatePicker("What time", selection: $notificationsManager.notification.notificationTime.animation(), displayedComponents: .hourAndMinute)
                        Button {
                            notificationsManager.scheduleNotification()
                        } label: {
                            Text(notificationsManager.notificationNeedsUpdating ? "Update notifications" : "Notifications up to date")
                        }
                        .disabled(!notificationsManager.notificationNeedsUpdating)
                    } else {
                        Text("You have disabled notifications. To change this, go to Settings > Kev Sez > Notifications.")
                    }

                } header: {
                    Text("notifications")
                }
            }
        }

//        updates UI based on whether notifications are enabled or not
        .onAppear(perform: notificationsManager.checkAuthorisationStatus)
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
