//
//  MenuView.swift
//  SwiftAppBundle
//
//  Created by Hernan Hawryluk on 15/08/2024.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: IMCView()) {
                    Text("IMC Calculator")
                }
                Text("App 2")
                Text("App 3")
                Text("App 4")
                Text("App 5")
            }
        }
    }
}

#Preview {
    MenuView()
}
