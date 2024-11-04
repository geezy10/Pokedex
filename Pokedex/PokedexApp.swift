//
//  PokedexApp.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 01.11.24.
//

import SwiftUI
import SwiftData

@main
struct PokedexApp: App {
    var body: some Scene {
        WindowGroup {
            PokemonListView(/*pokemons: []*/)
                .modelContainer(for: [PokemonModel.self])
        }
    }
}

