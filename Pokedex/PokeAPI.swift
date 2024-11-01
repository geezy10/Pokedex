//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 01.11.24.
//

import Foundation

//Codable to just read from the API
struct PokemonsDTO: Codable {
    let results: [PokemonDTO]
    //        let count: Int
    //        let next: String
    //        let previous: JSONNull?
   
}
//Data Transfer Object
struct PokemonDTO: Codable {
    let name: String
    let url: String
}


class PokeAPI {
    private var cachedPokemons: [PokemonDTO]?

    
    func getPokemons(completion: @escaping (PokemonDTO) -> ()) {
        // Use cached data if available
               if let cachedPokemons = cachedPokemons {
                   for pokemon in cachedPokemons {
                       completion(pokemon)
                   }
                   return
               }
        //guard checks if the URL is available, guards that it don´t crash, also possible with just an if
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100")
        else {print("Invalid URL")
            return }
        
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            guard let data = data
             else {  print("No data received from API")
                return
                }
            
        
            let pokemons = try! JSONDecoder().decode(PokemonsDTO.self, from: data)
            
            self.cachedPokemons = pokemons.results

            
            DispatchQueue.main.async {
               for pokemon in pokemons.results {
                    completion(pokemon)
                }
            }
        }.resume()
    }
}
