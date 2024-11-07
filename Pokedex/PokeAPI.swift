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

struct PokemonsDetailDTO: Codable {
    let sprites: PokemonDetailDTO
}	


struct PokemonDetailDTO: Codable {
    let id: Int
    let front_default: String?
}

class PokeAPI {
    
    //to cache pokemons, so we don´t make unnessecary API calls, private(set) -> read only property
    private(set) var cachedPokemons: [PokemonDTO]?
    //let  sortedPokemons = cachedPokemons?.sorted { $0.name < $1.name}
    
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
            let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
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
            print("stored \(pokemons.results.count) pokemons in cachedPokemons")
            
            
            
            //UI Updates must happen on the main thread
            DispatchQueue.main.async {
                for pokemonDTO in pokemons.results {
                    completion(pokemonDTO)
                }
            }
        }.resume()
    }
    
    
    
    func getDetail(url: String, completion: @escaping (PokemonDetailDTO) -> Void) {
        guard
            let url = URL(string: url)
        else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            (data: Data?, response: URLResponse?, error: Error?) in
            guard let data = data
            else {
                print("No data received from API")
                return
            }
            let pokemonDetailDTO = try! JSONDecoder().decode(
                PokemonDetailDTO.self, from: data)
            
            
            DispatchQueue.main.async {
                completion(pokemonDetailDTO)
            }
        }.resume()
    }
}








class ImageAPI {
    func getData(url:String, completion: @escaping(Data?) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}

