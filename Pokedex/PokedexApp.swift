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
            PokemonListView()
                .modelContainer(for: [PokemonModel.self, StatModel.self, TypeModel.self])
        }
    }
}

