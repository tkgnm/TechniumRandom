//
//  AdviceManager.swift
//  TechniumRandom
//
//  Created by Thomas King on 10/09/2022.
//

import Foundation

class AdviceManager: ObservableObject {

    let defaults = UserDefaults.standard
    static let shared = AdviceManager()

    var history = [Advice]()
    @Published var current = Advice(id: 0, advice: "About 99% of the time, the right time is right now.")
    @Published var techniumsUsedUp = false

    init() {
        if let data = defaults.object(forKey: "adviceHistory") as? Data {
            if let userHistory = try? JSONDecoder().decode([Advice].self, from: data) {
                history = userHistory
            }
        } else {
            createHistory()
        }
    }

    private func createHistory() {
        if let url = Bundle.main.url(forResource: "103stripped", withExtension: "txt") {
            if let techniumFile = try? String(contentsOf: url) {
                let seperatedLines = techniumFile.components(separatedBy: "\n")
                var idx = 0
                for line in seperatedLines {
                    history.append(Advice(id: idx, advice: line, dateRead: nil))
                    idx += 1
                }
            }
            newTechnium()
            return
        }
        fatalError("Could not load 103stripped.txt from bundle.")
    }

    func newTechnium() {
        guard history.filter( { $0.dateRead == nil }).count != 0 else {
            techniumsUsedUp = true
            return
        }

        let seenTechniums = history.filter({$0.dateRead != nil })
        var unseenTechniums = history.filter({$0.dateRead == nil }).shuffled()
        unseenTechniums[0].dateRead = Date.now
        history = unseenTechniums + seenTechniums
        current = history[0]
        history = history.sorted(by: { $0.dateRead?.compare($1.dateRead ?? Date.distantPast) == .orderedDescending })

        if let encoded = try? JSONEncoder().encode(history) {
            defaults.set(encoded, forKey: "adviceHistory")
        }
    }
}
