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
        List {
            ForEach(history) { technium in
            VStack {
                    Text(technium.advice)
                    Text(technium.dateAsString(technium.dateRead!))
                        .fontWeight(.light)
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: [Advice(id: 1, advice: "Advice 1", dateRead: Date.now),
                              Advice(id: 2, advice: "Advice 2", dateRead: Date.now),
                              Advice(id: 3, advice: "Advice 3", dateRead: Date.now)])
    }
}
