//
//  ContentView.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 01.11.24.
//

import SwiftUI
import SwiftData

struct PokemonListView: View {
    
    @State var pokemons: [PokemonModel] = []
    @State var searchText = ""
    @Environment(\.modelContext) var modelContext
    let pokeAPI = PokeAPI()
    
    var body: some View {
        NavigationView {
            List(pokemons, id: \.name) { pokemon in
                Text(pokemon.name)
            }
            .searchable(text: $searchText)
            //if data is loaded into onAppear, API will be called unnessecary bcs it wont change that much, for that the caching
            .onAppear {
                //caching, otherwise it will load every 100 pokemons every time the app is launched
                if pokemons.count == 0 {
                    pokeAPI.getPokemons() { pokemonDTO in
                        let pokemon = PokemonModel (name: pokemonDTO.name, url: pokemonDTO.url)
                        modelContext.insert(pokemon)
                        pokemons.append(pokemon)
                    }
                }
            }
            .navigationTitle("Gotta catch em all")
        }
    }
}

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View{
            PokemonListView(pokemons: [])
//                .preferredColorScheme(.dark)
//                .previewDisplayName("View List in Dark Mode")
            
        }
    }



