//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 01.11.24.
//

import Foundation

//Data Transfer Object to represent the JSON response, Codeable to encode the JSON
struct PokemonsDTO: Codable {
    let results: [PokemonDTO]
    //        let count: Int -> total number of pokemon
    //        let next: String -> url for the next pages of result (100)
    //        let previous: JSONNull?

}

struct PokemonDTO: Codable {
    let name: String
    let url: String
}

class PokeAPI {
    //to cache pokemons, so we don´t make unnessecary API calls
    private var cachedPokemons: [PokemonDTO]?

    func getPokemons(completion: @escaping (PokemonDTO) -> Void) {
        // check if there are cached pokemons, then loop trough each pokemon and call the completion handler for every pokemon
        if let cachedPokemons = cachedPokemons {
            for pokemon in cachedPokemons {
                completion(pokemon)
            }
            return
        }

        //guard checks if the URL is available, guards that it don´t crash, also possible with just an if
        guard
            let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100")
        else {
            print("Invalid URL")
            return
        }

        //asynchron network request running in the background without blocking the UI thread
        URLSession.shared.dataTask(with: url) {
            (data: Data?, response: URLResponse?, error: Error?) in  //represent the response from the API
            guard let data = data
            else {
                print("No data received from API")
                return
            }

            //tries to decode the json in pokemonDTO strucure
            let pokemons = try! JSONDecoder().decode(
                PokemonsDTO.self, from: data)

            //store it in the cache
            self.cachedPokemons = pokemons.results

            //UI Updates must happen on the main thread
            DispatchQueue.main.async {
                for pokemonDTO in pokemons.results {
                    completion(pokemonDTO)
                }
            }
        }.resume()
    }
}
