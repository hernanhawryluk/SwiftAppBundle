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
            List {
                NavigationLink(destination: IMCView()) {
                    Text("IMC Calculator")
                }
                NavigationLink(destination: SuperheroSearcher()) {
                    Text("Superhero Finder")
                }
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
