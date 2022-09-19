//
//  ContentView.swift
//  TechniumRandom
//
//  Created by Thomas King on 06/09/2022.
//

import SwiftUI

struct AdviceView: View {

    @StateObject var adviceManager = AdviceManager()
    @State private var taps = 0

    var body: some View {
        VStack {
            Text(adviceManager.current)
                .frame(height: 500)
                .onTapGesture {
                    taps += 1
                    if taps > 4 {
                        adviceManager.randomTechnium()
                        taps = 0
                    }
                }
//            Button {
//                adviceManager.randomTechnium()
//            } label: {
//                Text("Random advice")
//            }
        }
        .animation(.easeIn(duration: 1), value: adviceManager.current)
        .padding()
        .onAppear(perform: adviceManager.randomTechnium)
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}
