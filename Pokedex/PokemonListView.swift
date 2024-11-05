//
//  ContentView.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 01.11.24.
//

import SwiftData
import SwiftUI

struct PokemonListView: View {

    // @Query(sort: \PokemonModel.name)
    @Query var pokemons: [PokemonModel]
    @State var searchText = ""
    @Environment(\.modelContext) var modelContext
    let pokeAPI = PokeAPI()
    let imageAPI = ImageAPI()

    var body: some View {

        NavigationView {
            VStack {
                if let uiImage = UIImage(named: "PokeLogo") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 100)
                        .padding(10)

                }

                TextField("Search Pokémon", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 5)

                List(filteredPokemons) { pokemon in
                    HStack {
                        Text(pokemon.name.capitalized)
                        PokeIconView(pokemon: pokemon)
                    }
                }
                .onAppear {
                    print("pokemons count in SwiftData: \(pokemons.count)")
                    if pokemons.isEmpty {
                        fetchfromAPI()
                    } else {
                        print("Loaded from local storage")
                    }

                }

            }  //.searchable(text: $searchText)

        }
    }

    private func fetchfromAPI() {
        print("Loading from API...")
        pokeAPI.getPokemons { pokemonDTO in
            if !pokemons.contains(where: {
                $0.name == pokemonDTO.name
            }) {
                let pokemon = PokemonModel(
                    name: pokemonDTO.name, url: pokemonDTO.url)
                modelContext.insert(pokemon)  // Save to SwiftData
                if let cached = pokeAPI.cachedPokemons, cached.isEmpty {
                    print(
                        "there are \(pokemons.count) pokemons saved in SwiftData"
                    )
                }
                //                    pokemons.append(pokemon)
            } else {
                print("Duplicate detected, skipping \(pokemonDTO.name)")
            }
        }

    }

    var filteredPokemons: [PokemonModel] {
        if searchText.isEmpty {
            return pokemons
        } else {
            return pokemons.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView( /*pokemons:[] */)
            .modelContainer(for: [PokemonModel.self])
            .preferredColorScheme(.dark)
            .previewDisplayName("View List in Dark Mode")

    }
}
