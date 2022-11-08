//
//  ContentView.swift
//  TechniumRandom
//
//  Created by Thomas King on 06/09/2022.
//

import SwiftUI

struct AdviceView: View {

    @StateObject var adviceManager = AdviceManager.shared

    var body: some View {
        ScrollView {

            VStack {
                Text(adviceManager.current.advice)
                    .frame(height: 500)
                    .onTapGesture(count: 5, perform: adviceManager.randomTechnium)
                ForEach(adviceManager.history) { history in
                    if history.dateRead != nil {
                        Text(history.advice)
                            .fontWeight(.light)
                        Text(history.dateAsString(history.dateRead!))
                            .fontWeight(.light)
                    }
                }
                .padding()
            }
            .animation(.easeIn(duration: 1), value: adviceManager.current.advice)
            .padding()
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}
