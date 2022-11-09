//
//  AdviceManager.swift
//  TechniumRandom
//
//  Created by Thomas King on 10/09/2022.
//

import Foundation

class AdviceManager: ObservableObject {

    var history = [Advice]()
    @Published var current = Advice(id: 0, advice: "About 99% of the time, the right time is right now.")

    let defaults = UserDefaults.standard
    static let shared = AdviceManager()

    init() {
        if let data = defaults.object(forKey: "adviceHistory") as? Data {
            if let hist = try? JSONDecoder().decode([Advice].self, from: data) {
                history = hist
            }
        } else {
            createHistory()
        }
    }

    private func createHistory() {
        if let url = Bundle.main.url(forResource: "103stripped", withExtension: "txt") {
            if let techniumFile = try? String(contentsOf: url) {
                let seperatedLines = techniumFile.components(separatedBy: "\n")
                history = createAdviceArray(from: seperatedLines)
            }
            randomTechnium()
            return
        }
        fatalError("Could not load 103stripped.txt from bundle.")
    }

    private func createAdviceArray(from strArray: [String]) -> [Advice] {
        var arr = [Advice]()
        var idx = 0
        for line in strArray {
            arr.append(Advice(id: idx, advice: line, dateRead: nil))
            idx += 1
        }
        return arr
    }

    func randomTechnium() {
        guard history.allSatisfy( { $0.dateRead != nil }) else { return }

//        v inefficient. need to split into two arrays (like unseen techniums) and choose one at random
        while history[0].dateRead != nil {
            history.shuffle()
        }

        history[0].dateRead = Date.now
        current = history[0]

        history = history.sorted(by: { $0.dateRead?.compare($1.dateRead ?? Date.distantPast) == .orderedDescending })

        if let encoded = try? JSONEncoder().encode(history) {
            defaults.set(encoded, forKey: "adviceHistory")
        }
    }
}
