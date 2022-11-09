//
//  ContentView.swift
//  TechniumRandom
//
//  Created by Thomas King on 06/09/2022.
//

import SwiftUI

struct AdviceView: View {

    @StateObject var adviceManager = AdviceManager.shared
    var seenTechniums = [Advice]()

    var body: some View {
        ScrollView {

            VStack {
                Text(adviceManager.current.advice)
                    .frame(height: 500)
                    .onTapGesture(count: 5, perform: adviceManager.randomTechnium)
                ForEach(seenTechniums(from: adviceManager.history)) { technium in
                    Text(technium.advice)
                        .fontWeight(.light)
                    Text(technium.dateAsString(technium.dateRead!))
                        .fontWeight(.light)
                }
            }
            .padding()
        }
        .animation(.easeIn(duration: 1), value: adviceManager.current.advice)
        .padding()
    }

    func seenTechniums(from history: [Advice]) -> [Advice] {
        history.filter({$0.dateRead != nil})

    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}
