//
//  ContentView.swift
//  TechniumRandom
//
//  Created by Thomas King on 07/09/2022.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            DiscoverView()
                .padding()
                .tabItem {
                    Label("Discover", systemImage: "lightbulb")
                }
            AboutView()
                .padding()
                .tabItem {
                    Label("About", systemImage: "person.3.fill")
                }
            SettingsView()
                .padding()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
