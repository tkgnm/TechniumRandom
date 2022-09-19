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
    static let shared = AdviceManager()

    init() {
        
        if let url = Bundle.main.url(forResource: "103stripped", withExtension: "txt") {
            if let techniumFile = try? String(contentsOf: url) {
                let allLines = techniumFile.components(separatedBy: "\n")
                
                for line in allLines {
                    if !line.isEmpty {
                        all.append(line)
                    }
                    current = all.randomElement() ?? "About 99% of the time, the right time is right now."
                    return
                }
                fatalError("Could not load 103stripped.txt from bundle.")
            }
        }
    }

        func randomTechnium() {
            current = all.randomElement() ?? "About 99% of the time, the right time is right now."
        }
    }

