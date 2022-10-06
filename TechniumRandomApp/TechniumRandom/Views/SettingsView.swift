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
    @State private var notificationsDeniedAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("Enable notifications", isOn: $notificationsManager.notificationsEnabled).onTapGesture {
                        if notificationsManager.notificationsDenied {
                            notificationsDeniedAlert = true
                        }
                    }
                    if notificationsManager.notificationsEnabled {
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
                    }
                } header: {
                    Text("notifications")
                } footer: {
                    Text( notificationsManager.notificationsDenied ? "You have disabled notifications" : "")
                }
            }
        }
        //        updates UI based on whether notifications are enabled or not
        .onAppear(perform: notificationsManager.evaluateNotifications)
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                notificationsManager.checkAuthorisationStatus()
                notificationsManager.evaluateNotifications()
            }
        }
        .alert(isPresented: $notificationsDeniedAlert, content: {
            Alert(
                title: Text("You have disabled notifications"),
                message: Text("Turn on notifications in your apps settings"),
                primaryButton: .default(Text("Okay"), action: {
                    notificationsManager.notificationsEnabled = false
                }),
                secondaryButton: .cancel(Text("Settings"), action: {
                    notificationsManager.notificationsEnabled = false
                    notificationsManager.showAppSystemSettings()
                })
            )
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
