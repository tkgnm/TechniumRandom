//
//  AdviceManager.swift
//  TechniumRandom
//
//  Created by Thomas King on 10/09/2022.
//

import Foundation

class AdviceManager: ObservableObject {

    //    @Published var all = [String]()
    @Published var current = Advice(id: 0, advice: "")
    static let shared = AdviceManager()
    let defaults = UserDefaults.standard

    var history = [Advice]()

    init() {

        //        check for history
        if let data = defaults.object(forKey: "adviceHistory") as? Data {
            if let hist = try? JSONDecoder().decode([Advice].self, from: data) {
                history = hist
                current = history[0]
            }
        } else {
            createHistory()
        }
    }

    func createHistory() {
        if let url = Bundle.main.url(forResource: "103stripped", withExtension: "txt") {
            if let techniumFile = try? String(contentsOf: url) {

                let allLines = techniumFile.components(separatedBy: "\n")
                //        add all bits of advice to that history
                var idx = 0
                for line in allLines {
                    if !line.isEmpty {
                        history.append(Advice(id: idx, advice: line, dateRead: nil))
                        idx += 1
                    }
                }
            }
            //         save the history
            randomTechnium()
            return
        }
        fatalError("Could not load 103stripped.txt from bundle.")
    }

    func randomTechnium() {
        if history.allSatisfy( { $0.dateRead != nil }) {
            //            reset code here
            defaults.removeObject(forKey: "adviceHistory")
        }

        while history[0].dateRead != nil {
            history.shuffle()
            history[0].dateRead = Date.now
        }
        current = history[0]

        history = history.sorted(by: { $0.dateRead?.compare($1.dateRead ?? Date.distantPast) == .orderedDescending })

        if let encoded = try? JSONEncoder().encode(history) {
            defaults.set(encoded, forKey: "adviceHistory")
        }
    }
}
