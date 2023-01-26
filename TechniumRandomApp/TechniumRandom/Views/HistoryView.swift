//
//  HistoryView.swift
//  TechniumRandom
//
//  Created by Thomas King on 09/11/2022.
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) var dismiss

    var history: [Advice]

    var body: some View {
        Section {
            List {
                Section {
                    ForEach(history) { technium in
                        VStack {
                            Text(technium.advice)
                            Text(technium.stringFrom(date: technium.dateRead ?? Date.now))
//                                .frame(alignment: .trailing)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                } header: {
                    Text("Unlocked techniums")
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: [Advice(id: 1, advice: "About 99% of the time, the right time is right now.", dateRead: Date.now),
                              Advice(id: 2, advice: "No one is as impressed with your possessions as you are.", dateRead: Date.now),
                              Advice(id: 3, advice: "Dont ever work for someone you dont want to become.", dateRead: Date.now)])
    }
}
