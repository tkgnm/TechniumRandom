//
//  ContentView.swift
//  TechniumRandom
//
//  Created by Thomas King on 06/09/2022.
//

import SwiftUI

struct AdviceView: View {

    @StateObject var adviceManager = AdviceManager.shared
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
        }
        .animation(.easeIn(duration: 1), value: adviceManager.current)
        .padding()
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}
