//
//  AdviceManager.swift
//  TechniumRandom
//
//  Created by Thomas King on 10/09/2022.
//

import Foundation

class AdviceManager: ObservableObject {
    
    @Published var all = [String]()
    @Published var current = ""

    init() {

        if let url = Bundle.main.url(forResource: "103stripped", withExtension: "txt") {
            if let techniumFile = try? String(contentsOf: url) {
                let allLines = techniumFile.components(separatedBy: "\n")
                
                for line in allLines {
                    all.append(line)
                }
                current = all.randomElement() ?? "silkworm"
                return
            }
            fatalError("Could not load 103stripped.txt from bundle.")
        }
    }
    
    func randomTechnium() {
        current = all.randomElement() ?? all[0]
    }
}

