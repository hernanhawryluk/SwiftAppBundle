//
//  SuperheroSearcher.swift
//  SwiftAppBundle
//
//  Created by Hernan Hawryluk on 16/08/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct SuperheroSearcher: View {
    @State var superheroName: String = ""
    @State var wrapper: ApiNetwork.Wrapper? = nil
    @State var loading: Bool = false
    
    var body: some View {
        
        
        VStack {
            TextField("", text: $superheroName, prompt:
                Text("Nombre del superheroe")
                .font(.subheadline)
                    .foregroundColor(.gray))
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.purple, lineWidth: 2))
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
                .autocorrectionDisabled()
                .onSubmit {
                    loading = true
                    Task {
                        do {
                            wrapper = try await ApiNetwork().getHeroesByQuery(query: superheroName)
                            
                        } catch {
                            print("Error")
                        }
                        loading = false
                    }
                }
            VStack {
                if loading {
                    
                    Spacer()
                    ProgressView().tint(.white).scaleEffect(CGSize(width: 1.8, height: 1.8))
                    Spacer()
                    
                } else {
                    NavigationStack {
                        List(wrapper?.results ?? []) { superhero in
                            ZStack{
                                SuperheroItem(superhero: superhero)
                                NavigationLink(destination: SuperheroDetail(id: superhero.id, name: superhero.name)) {
                                    EmptyView()
                                        .opacity(0)
                                }
                            }.listRowBackground(Color.backgroundApp)
                        }.listStyle(.plain)
                    }
                    Spacer()
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(.backgroundApp)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(.backgroundApp)
            .background(.backgroundApp).toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Superhero Finder").foregroundColor(.white)
                }
            }
    }
}

struct SuperheroItem: View {
    let superhero: ApiNetwork.Results
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.backgroundComponent)
            WebImage(url: URL(string: superhero.image.url))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(height: 200)
            VStack{
                Spacer()
                Text(superhero.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 42)
                    .background(.backgroundComponent.opacity(0.4))
            }
        }.frame(height: 200).cornerRadius(10).listRowBackground(Color.backgroundApp)
        
    }
    
}

#Preview {
    SuperheroSearcher(superheroName: "Super")
}
