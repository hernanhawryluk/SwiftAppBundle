//
//  SuperheroDetail.swift
//  SwiftAppBundle
//
//  Created by Hernan Hawryluk on 16/08/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Charts

struct SuperheroDetail: View {
    let id: String
    let name: String
    
    @State var superhero: ApiNetwork.SuperheroCompleted? = nil
    @State var loading: Bool = true
    
    var body: some View {
       
        ScrollView {
            VStack{
                if loading {
                    Spacer()
                    ProgressView().tint(.white).scaleEffect(1.5)
                    Spacer()
                } else if let superhero = superhero {
                    WebImage(url: URL(string: superhero.image.url))
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                    Text(superhero.name).bold().font(.title).foregroundColor(.white)
                    ForEach(superhero.biography.aliases, id: \.self) { alias in
                        Text(alias).foregroundColor(.gray).italic()
                    }
                    SuperheroStats(stats: superhero.powerstats)
                    Spacer()
                }
            }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundApp)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(name).foregroundColor(.white)
                }
            }.navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.backgroundApp, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                Task {
                    do {
                        superhero = try await ApiNetwork().getHeroById(id: id)
                    } catch {
                        superhero = nil
                    }
                    loading = false
                }
        }
    }
}

struct SuperheroStats: View {
    let stats: ApiNetwork.Powerstats
    
    var body: some View {
        VStack {
            Chart {
                SectorMark(angle: .value("Count",
                                         Int(stats.combat) ?? 0),
                           innerRadius: .ratio(0.5),
                           angularInset: 2
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Combate"))
                    
                SectorMark(angle: .value("Count",
                                         Int(stats.durability) ?? 0),
                           innerRadius: .ratio(0.5),
                           angularInset: 2
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Inteligencia"))
                SectorMark(angle: .value("Count",
                                         Int(stats.intelligence) ?? 0),
                           innerRadius: .ratio(0.5),
                           angularInset: 2
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Poder"))
                SectorMark(angle: .value("Count",
                                         Int(stats.power) ?? 0),
                           innerRadius: .ratio(0.5),
                           angularInset: 2
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Velocidad"))
                SectorMark(angle: .value("Count",
                                         Int(stats.speed) ?? 0),
                           innerRadius: .ratio(0.5),
                           angularInset: 2
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Fuerza"))
                SectorMark(angle: .value("Count",
                                         Int(stats.strength) ?? 0),
                           innerRadius: .ratio(0.5),
                           angularInset: 2
                ).cornerRadius(5)
                    .foregroundStyle(by: .value("Category", "Durabilidad"))
            }.padding(16)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            .cornerRadius(16)
            .padding(24)
    }
}

#Preview {
    SuperheroDetail(id: "63", name: "Batygirl")
}
