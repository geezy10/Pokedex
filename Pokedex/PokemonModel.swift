//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 01.11.24.
//

import Foundation
import SwiftUI
import SwiftData

@Model // Stored in SwiftData (local database)

//own models to not have the objects from the API 
class PokemonModel {
    var id: Int
    var name: String
    var url: String?
    var imageURL: String?
    
    init(id: Int,name: String, url: String/*, imageURL: String*/){
        self.id = id
        self.name = name
        self.url = url
//        self.imageURL = imageURL

    }}

