import Foundation
import SwiftData
import SwiftUI

@Model
class PokemonModel {
    var id: Int
    var name: String
    var url: String?
    var height: Int
    var weight: Int
    var imageURL: String?
    var stats: [StatModel]  // Use StatModel for local storage
//    var types: [TypeModel]

    init(
        id: Int, name: String, url: String, imageURL: String, weight: Int,
        height: Int, stats: [StatModel]/*, types: [TypeModel]*/
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.imageURL = imageURL
        self.stats = stats
        self.height = height
        self.weight = weight
//        self.types = types
    }

    var hp: Int {
        stats.first(where: { $0.statName == "hp" })?.baseStat ?? 0
    }

    var attack: Int {
        stats.first(where: { $0.statName == "attack" })?.baseStat ?? 0
    }

    var defense: Int {
        stats.first(where: { $0.statName == "defense" })?.baseStat ?? 0
    }

    var specialAttack: Int {
        stats.first(where: { $0.statName == "special-attack" })?.baseStat ?? 0
    }

    var specialDefense: Int {
        stats.first(where: { $0.statName == "special-defense" })?.baseStat ?? 0
    }

    var speed: Int {
        stats.first(where: { $0.statName == "speed" })?.baseStat ?? 0
    }
}

// Define StatModel specifically for the local storage needs
struct StatModel: Codable {
    var baseStat: Int
    var effort: Int
    var statName: String
    
    init(baseStat: Int, effort: Int, statName: String) {
        self.baseStat = baseStat
        self.effort = effort
        self.statName = statName
    }
}
//    struct TypeModel: Codable {
//        var slot: Int        // The slot or order for the type (if Pokémon has multiple types)
//        var typeName: String // The name of the type, like "fire" or "water"
//        
//        init(slot: Int, typeName: String) {
//            self.slot = slot
//            self.typeName = typeName
//        }
//    }
//

