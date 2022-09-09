//
//  SettingsView.swift
//  TechniumRandom
//
//  Created by Thomas King on 08/09/2022.
//

import SwiftUI

struct SettingsView: View {

    @State private var notificationsOn = true

    var body: some View {
        Form {
            Section {
                Toggle("Turn notifications on", isOn: $notificationsOn)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
