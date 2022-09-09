//
//  ContentView.swift
//  TechniumRandom
//
//  Created by Thomas King on 06/09/2022.
//

import SwiftUI

struct DiscoverView: View {

    @State private var techniums = [String]()
    @State private var currentTechnium = ""

    var body: some View {
        VStack {
            Text(currentTechnium)
                .frame(height: 500)
            Button {
                randomTechnium()
            } label: {
                Text("Random advice")
            }
        }
        .animation(.easeIn(duration: 1), value: currentTechnium)
        .onAppear(perform: start)
        .padding()
    }

    func start() {

        if techniums.count > 0 {
            return
        }

        if let url = Bundle.main.url(forResource: "103stripped", withExtension: "txt") {
            if let techniumFile = try? String(contentsOf: url) {

                    let allLines = techniumFile.components(separatedBy: "\n")
                for line in allLines {
                    techniums.append(line)
                }
                currentTechnium = allLines.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load 103stripped.txt from bundle.")
    }

    func randomTechnium() {
        currentTechnium = techniums.randomElement() ?? techniums[0]
    }

}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
