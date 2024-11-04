//
//  PokeIconView.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 04.11.24.
//

import Foundation
import SwiftUI

struct PokeIconView: View {
    
    @Bindable var pokemon: PokemonModel
    var body: some View {
        if let imageData = pokemon.image {
            Image(uiImage: UIImage(data: imageData)!)
        } else {
            Text("(a wild haris appeared)")
                
        }}
}
