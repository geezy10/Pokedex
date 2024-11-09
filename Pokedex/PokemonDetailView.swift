//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Haris Kekic on 08.11.24.
//

import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonModel

    var body: some View {
        VStack {
            Text("ID: \(pokemon.id)")
                .font(.title)
                .padding(.top)

            Text("Name: \(pokemon.name.capitalized)")
                .font(.title)

            Text("Weight: \(pokemon.weight)")
                .font(.title3)

            Text("Height: \(pokemon.height)")
                .font(.title3)
  
//            // Display formatted types
//            Text("Types: \(pokemon.types.map { $0.typeName.capitalized }.joined(separator: ", "))")
//                .font(.title3)
//                .foregroundColor(.secondary)

            if let imageURL = pokemon.imageURL, let url = URL(string: imageURL)
            {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Text("No Image Available")
                    .font(.caption)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Stats:")
                    .font(.title2)
                    .padding(.top)

                Text("HP: \(pokemon.hp)")
                Text("Attack: \(pokemon.attack)")
                Text("Defense: \(pokemon.defense)")
                Text("Special Attack: \(pokemon.specialAttack)")
                Text("Special Defense: \(pokemon.specialDefense)")
                Text("Speed: \(pokemon.speed)")
                Spacer()
            }
            .padding()
            .navigationTitle(pokemon.name.capitalized)
        }
    }

}
#Preview {
    let samplePokemon = PokemonModel(
        id: 1,
        name: "bulbasaur",
        url: "https://pokeapi.co/api/v2/pokemon/1",
        imageURL:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
        weight: 69,
        height: 7,
        stats: [
            StatModel(baseStat: 45, effort: 0, statName: "hp"),
            StatModel(baseStat: 49, effort: 0, statName: "attack"),
            StatModel(baseStat: 49, effort: 0, statName: "defense"),
            StatModel(baseStat: 65, effort: 0, statName: "special-attack"),
            StatModel(baseStat: 65, effort: 0, statName: "special-defense"),
            StatModel(baseStat: 45, effort: 0, statName: "speed"),
        ]
//        types: [
//            TypeModel(slot: 1, typeName: "grass"),
//            TypeModel(slot: 2, typeName: "poison"),
//        ]
    )
    PokemonDetailView(pokemon: samplePokemon)
}
