//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 01.11.24.
//

import Foundation
import SwiftUI
import SwiftData

@Model

//own models to not have the objects from the API 
class PokemonModel {
    var id: UUID
    var name: String
    var url: String

    init(name: String, url: String){
        self.id = UUID()
        self.name = name
        self.url = url
    }
}
