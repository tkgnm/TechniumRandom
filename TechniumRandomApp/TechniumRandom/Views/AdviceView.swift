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
        NavigationView {
            VStack {
                Text(adviceManager.current.advice)
                    .frame(height: 500)
                    .onTapGesture(count: 5, perform: adviceManager.newTechnium)
            }
            .animation(.easeIn(duration: 1), value: adviceManager.current.advice)
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        HistoryView(history: adviceManager.seenTechniums)
                    } label: {
                        Label("History", systemImage: "clock")
                    }
                }
            }
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}
