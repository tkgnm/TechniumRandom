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
        VStack {
            Text(adviceManager.current.advice)
                .frame(height: 500)
                .onTapGesture(count: 5, perform: adviceManager.randomTechnium)
        }
        .animation(.easeIn(duration: 1), value: adviceManager.current.advice)
        .padding()
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}
