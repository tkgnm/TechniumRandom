//
//  Advice.swift
//  TechniumRandom
//
//  Created by Thomas King on 07/11/2022.
//

import Foundation

struct Advice: Codable, Identifiable {
    let id: Int
    let advice: String
    var dateRead: Date?

    func dateAsString(_ dateRead: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"
        return dateFormatter.string(from: dateRead)
    }
}
