//
//  AdviceManager.swift
//  TechniumRandom
//
//  Created by Thomas King on 10/09/2022.
//

import Foundation

class AdviceManager: ObservableObject {

//    @Published var all = [String]()
    @Published var current = Advice(advice: "")
    static let shared = AdviceManager()
    let defaults = UserDefaults.standard

    var history = [Advice]()

    init() {

        //        check for history
        if let data = defaults.object(forKey: "adviceHistory") as? Data {
            if let hist = try? JSONDecoder().decode([Advice].self, from: data) {
                history = hist
            }
        } else {
            //  make history
            if let url = Bundle.main.url(forResource: "103stripped", withExtension: "txt") {
                if let techniumFile = try? String(contentsOf: url) {

                    let allLines = techniumFile.components(separatedBy: "\n")
                    //        add all bits of advice to that history
                    for line in allLines {
                        if !line.isEmpty {
                            history.append(Advice(advice: line, dateRead: nil))
                        }
                    }
                }

                //        set a new one for 'current' at random and assign it a date
                history.shuffle()
                history[0].dateRead = Date.now
                current = history[0]


                //         save the history
                if let encoded = try? JSONEncoder().encode(history) {
                    defaults.set(encoded, forKey: "adviceHistory")
                }

                randomTechnium()
                return
            }
            fatalError("Could not load 103stripped.txt from bundle.")
        }
    }

    func randomTechnium() {
        current = history.randomElement()!
    }
}
