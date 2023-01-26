//
//  ContentView.swift
//  TechniumRandom
//
//  Created by Thomas King on 07/09/2022.
//

import SwiftUI

struct ContentView: View {

    @StateObject var tabController = TabController.shared

    var body: some View {
        TabView(selection: $tabController.activeTab) {
            AdviceView()
                .tag(Tab.advice)
                .tabItem {
                    Label("Advice", systemImage: "cloud.fill")
                }
            AboutView()
                .tag(Tab.about)
                .tabItem {
                    Label("About", systemImage: "person.3.fill")
                }
            SettingsView()
                .tag(Tab.settings)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .environmentObject(tabController)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
