//
//  ContentView.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 01.11.24.
//

import SwiftData
import SwiftUI

struct PokemonListView: View {

    //    @Query(sort: \PokemonModel.name)
    @Query var pokemons: [PokemonModel]
    @State var searchText = ""
    @Environment(\.modelContext) var modelContext
    let pokeAPI = PokeAPI()

    var body: some View {

        NavigationView {
            List(filteredPokemons) { pokemon in
                Text(pokemon.name.capitalized)
            }
            .searchable(text: $searchText)
            .onAppear {
                print("pokemons count in SwiftData: \(pokemons.count)")
                if pokemons.isEmpty {
                    fetchfromAPI()
                } else {
                    print("Loaded from local storage")
                }

            }  //.navigationDocument(<#T##url: URL##URL#>)
            .navigationTitle("Pokedex")

        }
    }

    
    private  func fetchfromAPI() {
        print("Loading from API...")
        pokeAPI.getPokemons { pokemonDTO in
            if !pokemons.contains(where: {
                $0.name == pokemonDTO.name
            } ) {
                let pokemon = PokemonModel(
                    name: pokemonDTO.name, url: pokemonDTO.url)
                modelContext.insert(pokemon)  // Save to SwiftData
                //                    pokemons.append(pokemon)
            }  else { print("Duplicate detected, skipping \(pokemonDTO.name)")}
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
            .preferredColorScheme(.dark)
            .previewDisplayName("View List in Dark Mode")

    }
}
