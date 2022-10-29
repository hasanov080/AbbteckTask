//
//  Model.swift
//  RickAndMorti
//
//  Created by Hasan Hasanov on 28.10.22.
//

import UIKit
import SDWebImage

enum Gender: String{
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown
}
enum Status: String{
    case alive = "Alive"
    case dead = "Dead"
    case unknown
}

struct CharactersResponse: Codable {
    let info: Info?
    var results: [Characters]?
}

// MARK: - Info
struct Info: Codable {
    let count, pages: Int?
    let next: String?
    let prev: String?
}

// MARK: - Result
struct Characters: Codable {
    let id: Int?
    let name, status, species, type: String?
    let gender: String?
    let origin, location: Location?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.species = try container.decodeIfPresent(String.self, forKey: .species)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.origin = try container.decodeIfPresent(Location.self, forKey: .origin)
        self.location = try container.decodeIfPresent(Location.self, forKey: .location)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.episode = try container.decodeIfPresent([String].self, forKey: .episode)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.created = try container.decodeIfPresent(String.self, forKey: .created)
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case image
        case episode
        case url
        case created
    }
}

// MARK: - Location
struct Location: Codable {
    let name: String?
    let url: String?
}

