//
//  Place.swift
//  SwiftAppBundle
//
//  Created by Hernan Hawryluk on 17/08/2024.
//

import Foundation
import MapKit

struct Place: Identifiable {
    let id = UUID()
    var name: String
    var coordinates: CLLocationCoordinate2D
    var favorite: Bool
}
