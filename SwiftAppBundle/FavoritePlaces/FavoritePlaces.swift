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
                }                    .onTapGesture { coord in
                        if let coordinates = proxy.convert(coord, from: .local) {
                            showPopUp = coordinates
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
                
            }
        }
    
    func savePlace(name: String, favorite: Bool, coordinates: CLLocationCoordinate2D) {
        let place = Place(name: name, coordinates: coordinates, favorite: favorite)
        places.append(place)
    }
    
    func clearForm() {
        name = ""
        favorite = false
        error = false
        showPopUp = nil
    }
}

#Preview {
    FavoritePlaces()
}
