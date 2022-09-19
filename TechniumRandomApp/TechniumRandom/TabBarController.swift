//
//  TabBarController.swift
//  TechniumRandom
//
//  Created by Thomas King on 19/09/2022.
//

import Foundation

enum Tab {
    case advice
    case about
    case settings
}

class TabController: ObservableObject {

    static let shared = TabController()

    @Published var activeTab = Tab.advice

    func open(_ tab: Tab) {
        activeTab = tab
    }
}
