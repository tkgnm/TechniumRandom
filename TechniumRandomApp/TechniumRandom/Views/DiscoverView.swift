//
//  ContentView.swift
//  TechniumRandom
//
//  Created by Thomas King on 06/09/2022.
//

import SwiftUI

struct DiscoverView: View {

    @StateObject var adviceManager = AdviceManager()

    var body: some View {
        VStack {
            Text(adviceManager.current)
                .frame(height: 500)
            Button {
                adviceManager.randomTechnium()
            } label: {
                Text("Random advice")
            }
        }
        .animation(.easeIn(duration: 1), value: adviceManager.current)
        .padding()
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
