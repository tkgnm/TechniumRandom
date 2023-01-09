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

    var seenTechniums = [Advice]()
    var unseenTechniums = [Advice]()
    
    @Published var current = Advice(id: 0, advice: "About 99% of the time, the right time is right now.")
    @Published var techniumsUsedUp = false

    init() {
        if let data = defaults.object(forKey: "adviceHistory") as? Data {
            if let userHistory = try? JSONDecoder().decode([Advice].self, from: data) {
                seenTechniums = userHistory.filter({$0.dateRead != nil })
                unseenTechniums = userHistory.filter({$0.dateRead == nil }).shuffled()
                current = seenTechniums[0]
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
                    unseenTechniums.append(Advice(id: idx, advice: line, dateRead: nil))
                    idx += 1
                }
            }
            newTechnium()
            return
        }
        fatalError("Could not load 103stripped.txt from bundle.")
    }

    func newTechnium() {
        guard unseenTechniums.count != 0 else {
            techniumsUsedUp = true
            return
        }

        unseenTechniums[0].dateRead = Date.now
        current = unseenTechniums[0]

        seenTechniums.append(current)
        unseenTechniums.removeFirst(1)
        
        seenTechniums = seenTechniums.sorted(by: { $0.dateRead?.compare($1.dateRead ?? Date.distantPast) == .orderedDescending })

        if let encoded = try? JSONEncoder().encode(seenTechniums + unseenTechniums) {
            defaults.set(encoded, forKey: "adviceHistory")
        }
    }
}
