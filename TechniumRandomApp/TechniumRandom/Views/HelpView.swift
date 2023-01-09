//
//  HelpView.swift
//  TechniumRandom
//
//  Created by Thomas King on 14/11/2022.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack {
            Text("How to get started")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Text("You've not turned on notifications. To see more of Kevin Kelly's advice, please go to settings and turn on notifications. You can choose how often and when to receive notifications.")
                .padding()
            Image(systemName: "arrow.down")
                .position(x:(UIScreen.main.bounds.size.width / 6) * 5, y: 0)
        }
    }
    
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
