//
//  ApiNetwork.swift
//  SwiftAppBundle
//
//  Created by Hernan Hawryluk on 16/08/2024.
//

import Foundation

class ApiNetwork {
    
    struct Wrapper: Codable {
        let response: String
        let results: [Results]
    }
    
    struct Results: Codable, Identifiable {
        let id: String
        let name: String
        let image: Image
    }
    
    struct Image: Codable {
        let url: String
    }

    func getHeroesByQuery(query: String) async throws -> Wrapper {
        let url = URL(string: "https://superheroapi.com/api/123835c77276f8b93afe1af572c3e360/search/\(query)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let wrapper = try JSONDecoder().decode(Wrapper.self, from: data)
        
        return wrapper
    }
    
    struct SuperheroCompleted: Codable {
        let id: String
        let name: String
        let image: Image
        let powerstats: Powerstats
        let biography: Biography
    }
    
    struct Powerstats: Codable {
        let intelligence: String
        let strength: String
        let speed: String
        let durability: String
        let power: String
        let combat: String
    }
    
    struct Biography: Codable {
        let alignment: String
        let publisher: String
        let aliases: [String]
        let fullName: String
        
        enum CodingKeys: String, CodingKey {
            case alignment = "alignment"
            case publisher = "publisher"
            case aliases = "aliases"
            case fullName = "full-name"
        }
    }
    
    func getHeroById(id: String) async throws -> SuperheroCompleted {
        let url = URL(string: "https://superheroapi.com/api/123835c77276f8b93afe1af572c3e360/\(id)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let superhero = try JSONDecoder().decode(SuperheroCompleted.self, from: data)
        
        return superhero
    }
}
