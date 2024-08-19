//
//  FavoritePlaces.swift
//  SwiftAppBundle
//
//  Created by Hernan Hawryluk on 17/08/2024.
//

import SwiftUI
import MapKit

struct FavoritePlaces: View {
    
    
    @State var position = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: -34.8215847, longitude: -58.4660282),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    )
    
    @State var places: [Place] = []
    @State var showPopUp: CLLocationCoordinate2D? = nil
    @State var name: String = ""
    @State var favorite: Bool = false
    @State var error: Bool = false
    @State var showSheet = false
    
    let height = stride(from: 0.15, through: 0.15, by: 0.1).map { PresentationDetent.fraction(($0))}
    var body: some View {
        ZStack {
            MapReader { proxy in
                Map(position: $position) {
                    ForEach(places) { place in
                        Annotation(place.name, coordinate: place.coordinates) {
                            let color = if place.favorite {
                                Color.yellow
                            } else {
                                Color.black
                            }
                            Circle()
                                .stroke(color, lineWidth: 3)
                                .fill(.white)
                                .frame(width: 12)
                        }
                    }
                }
                .onTapGesture { coord in
                        if let coordinates = proxy.convert(coord, from: .local) {
                            showPopUp = coordinates
                        }
                }
                .overlay {
                    VStack{
                        Button("Show list") {
                            showSheet = true
                        }.padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.white)
                            .cornerRadius(16)
                            .padding(16)
                        Spacer()
                    }
                }
            }
                
                if showPopUp != nil {
                    
                    let View = VStack {
                        let auth = if error == true { Color.red } else { Color.gray }
                        Text("Añadir localización").font(.title2).bold()
                        Spacer()
                        TextField("Nombre", text: $name).frame(height: 10)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(auth, lineWidth: 2))
                            .padding(.bottom, 8)
                        Toggle("¿Es un lugar favorito?", isOn: $favorite)
                        Spacer()
                        Button("Guardar") {
                            if (name != ""){
                                savePlace(name: name, favorite: favorite, coordinates: showPopUp!)
                                clearForm()
                            } else {
                                error = true
                            }
                        }
                    }
                    withAnimation {
                        CustomDialog(closeDialog: {
                            showPopUp = nil
                        }, onDismissOutside: true, content: View)
                    }
                }
            
        }.sheet(isPresented: $showSheet, content: {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(places) { place in
                        let color = if place.favorite == true {
                            Color.yellow.opacity(0.5)
                        } else {
                            Color.black.opacity(0.5)
                        }
                        VStack {
                            Text(place.name).font(.title3).bold()
                        }.frame(width: 150, height: 100).cornerRadius(16).overlay {
                            RoundedRectangle(cornerRadius: 20).stroke(color.opacity(0.5), lineWidth: 1)
                        }.shadow(radius: 5).padding(.horizontal, 8).padding(.top, 10)
                            .onTapGesture {
                                animateCamera(coordinates: place.coordinates)
                                showSheet = false
                            }
                    }
                }
            }.presentationDetents(Set(height))
        }).onAppear{
            loadPlaces()
        }
    }
    
    func animateCamera (coordinates: CLLocationCoordinate2D) {
        withAnimation {
            position = MapCameraPosition.region(MKCoordinateRegion(
                center: coordinates,
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
            )
        }
    }
    
    func savePlace(name: String, favorite: Bool, coordinates: CLLocationCoordinate2D) {
        let place = Place(name: name, coordinates: coordinates, favorite: favorite)
        places.append(place)
        savePlaces()
    }
    
    func clearForm() {
        name = ""
        favorite = false
        error = false
        showPopUp = nil
    }
}

extension FavoritePlaces {
    func savePlaces() {
        if let encodeData = try? JSONEncoder().encode(places) {
            UserDefaults.standard.set(encodeData, forKey: "places")
        }
    }
    
    func loadPlaces() {
        if let savedPlaces = UserDefaults.standard.data(forKey: "places"),
           let decodedPlaces = try? JSONDecoder().decode([Place].self, from: savedPlaces) {
               places = decodedPlaces
           }
    }
}

#Preview {
    FavoritePlaces()
}
