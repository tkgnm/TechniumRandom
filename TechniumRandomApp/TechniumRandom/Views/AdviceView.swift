//
//  ContentView.swift
//  TechniumRandom
//
//  Created by Thomas King on 06/09/2022.
//

import SwiftUI

struct AdviceView: View {
    
    @StateObject var adviceManager = AdviceManager.shared
    @State private var showHistory = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text(adviceManager.current.advice)
                        .frame(height: 500)
                        .onTapGesture(count: 5, perform: adviceManager.newTechnium)
                }
            }
            .animation(.easeIn(duration: 1), value: adviceManager.current.advice)
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("History") {
                        showHistory.toggle()
                    }
                }
            }
            .sheet(isPresented: $showHistory) {
                HistoryView(history: adviceManager.seenTechniums)
            }
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}
