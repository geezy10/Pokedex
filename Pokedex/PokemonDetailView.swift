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
            Text("Id: \(pokemon.id)")
                .font(.title)
            Text("Name: \(pokemon.name.capitalized)")
                .font(.title)

            if let imageURL = pokemon.imageURL, let url = URL(string: imageURL) {
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
            
            Text("Type: ")
                .font(.title)
            HStack(alignment: .top) {
                Text("Entry: ")
                    .font(.title)
                    
                Text("placeholder asfasdfasdfasd asdfasfasfasf asdfasdfasdfasdf asdfas asdfasfasdfasf asdfasdfasfasfasfasdfasfasf asdfasdfasdfasfs")
                    .font(.title)
            }
            
            
            Spacer()
        }
        .padding()
        .navigationTitle(pokemon.name.capitalized)
    }
}

#Preview {
    let samplePokemon = PokemonModel(id: 1, name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1", imageURL: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
    PokemonDetailView(pokemon: samplePokemon)
}

