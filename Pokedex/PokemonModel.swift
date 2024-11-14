import Foundation
import SwiftData
import SwiftUI

@Model
class PokemonModel {
    var id: Int
    var name: String
    var url: String?
    var height: Double
    var weight: Double
    var imageURL: String?
    var flavorText: String?

    @Relationship var stats: [StatModel]
    @Relationship var types: [TypeModel]

    init(
        id: Int, name: String, url: String, imageURL: String, weight: Double,
        height: Double, stats: [StatModel], types: [TypeModel],
        flavorText: String? = nil
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.imageURL = imageURL
        self.stats = stats
        self.height = height
        self.weight = weight
        self.types = types
        self.flavorText = flavorText

    }

    // Computed property to get a formatted string of type names
    var typeNames: String {
        types.map { $0.typeName.capitalized }.joined(separator: ", ")
    }
    //Computed property to get the colors for the gradient based on types
    var typeColors: [Color] {
        types.prefix(2).map { $0.color }  // Use only the first two types, if they exist
    }
    var formattedWeight: String {
        String(format: "%.1f kg", weight / 10)
    }

    var formattedHeight: String {
        String(format: "%.1f m", height / 10)
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

@Model
class StatModel: Identifiable {
    var id = UUID()
    var baseStat: Int
    var effort: Int
    var statName: String

    init(baseStat: Int, effort: Int, statName: String) {
        self.baseStat = baseStat
        self.effort = effort
        self.statName = statName
    }
}
@Model
class TypeModel: Identifiable {
    var id = UUID()
    var slot: Int
    var typeName: String

    init(slot: Int, typeName: String) {
        self.slot = slot
        self.typeName = typeName
    }
    var color: Color {
        switch typeName.lowercased() {
        case "grass": return .green
        case "fire": return .red
        case "water": return .blue
        case "electric": return .yellow
        case "ice": return .cyan
        case "fighting": return .orange
        case "poison": return .purple
        case "ground": return .brown
        case "flying": return .blue.opacity(0.5)
        case "psychic": return .pink
        case "bug": return .green.opacity(0.7)
        case "rock": return .gray
        case "ghost": return .purple.opacity(0.7)
        case "dragon": return .indigo
        case "dark": return .black
        case "steel": return .gray.opacity(0.6)
        case "fairy": return .pink.opacity(0.7)
        default: return .gray
        }
    }
}
