//
//  SettingsView.swift
//  TechniumRandom
//
//  Created by Thomas King on 06/09/2022.
//

import SwiftUI

struct AboutView: View {

    @State private var devs = [String]()

    var body: some View {
        ScrollView {
            VStack {
                Text("The Technium 103")
                    .font(.title)
                    .padding()
                Text("All advice you receive on this app was written by Kevin Kelly (b. 1952). This app aims to provide a simple interface for receiving Kevin's advice.")
//                maybe get some links here to the website.
                    .padding()
                Text("[Kevin Kelly's website](https://kk.org)")
                Text("Credits")
                    .font(.title2)
                    .padding()
                Text("This app was made by Thomas King. It is dedicated to The Guardian's apps team whose wisdom I have been very fortunate to receive and without whom I would not have even made this app. Specifically, those people are:")
                    .padding()
                ForEach(devs, id: \.self) { dev in
                    Text(dev)
//                        .padding()
                }
            }
        }
        .onAppear(perform: start)
    }

    func start() {

        if devs.count > 0 {
            return
        }
        
        if let url = Bundle.main.url(forResource: "guardianappsteam", withExtension: "txt") {
            if let appsTeamFile = try? String(contentsOf: url) {

                let allLines = appsTeamFile.components(separatedBy: "\n")

                for line in allLines {
                    devs.append(line)
                    devs.sort()
                }
//                currentTechnium = allLines.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load guardianappsteam.txt from bundle.")
    }

}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
