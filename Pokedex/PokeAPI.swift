//
//  PokeAPI.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 01.11.24.
//

import Foundation

// Represents the main list response, containing an array of PokemonDTO
struct PokemonsDTO: Codable {
    let results: [PokemonDTO]
}

// Represents each Pokemon item in the list
struct PokemonDTO: Codable {
    let name: String
    let url: String
}

// Represents the detailed response for an individual Pokemon
struct PokemonDetailDTO: Codable {
    let id: Int
    let sprites: Sprites
    let weight: Double
    let height: Double
    let stats: [Stat]
    let types: [TypeElement]
}

struct TypeElement: Codable {
    let slot: Int
    let type: TypeInfo
}

struct TypeInfo: Codable {
    let name: String
    let url: String
}

// Represents the sprite/image URLs for a Pokemon
struct Sprites: Codable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

// Represents individual stat details for a Pokemon
struct Stat: Codable {
    let baseStat: Int
    let effort: Int
    let stat: StatName

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

// Represents the stat name and URL, like "hp", "attack"
struct StatName: Codable {
    let name: String
    let url: String
}

class PokeAPI {
    

    //to cache pokemons, so we don´t make unnessecary API calls, private(set) -> read only property
    private(set) var cachedPokemons: [PokemonDTO]?

    func getPokemons(forGeneration generation: Int, completion: @escaping (PokemonDTO) -> Void) {
        // check if there are cached pokemons, then loop trough each pokemon and call the completion handler for every pokemon
//        if let cachedPokemons = cachedPokemons {
//            for pokemon in cachedPokemons {
//                completion(pokemon)
//            }
//            return
//        }
//
        cachedPokemons = nil
        
        let url: URL?
               switch generation {
               case 1:
                   url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0")
               case 2:
                   url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=100&offset=151")
               case 3:
                   url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=135&offset=251")
               case 4:
                   url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=107&offset=386")
               case 5:
                   url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=156&offset=493")
               case 6:
                   url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=72&offset=649")
               case 7:
                   url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=88&offset=721")
               case 8:
                   url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=96&offset=809")
               case 9:
                   url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=105&offset=905")
               default:
                   url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
               }

        

        //guard checks if the URL is available, guards that it don´t crash, also possible with just an if
        guard
            let url = url 
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

            do {
                let pokemons = try JSONDecoder().decode(
                    PokemonsDTO.self, from: data)
                self.cachedPokemons = pokemons.results
                DispatchQueue.main.async {
                    for pokemonDTO in pokemons.results {
                        completion(pokemonDTO)
                    }
                }
            } catch {
                print("Error decoding PokemonsDTO:", error)
            }
        }.resume()
    }

    func getDetail(
        url: String, completion: @escaping (PokemonDetailDTO) -> Void
    ) {
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
            do {
                let pokemonDetailDTO = try JSONDecoder().decode(
                    PokemonDetailDTO.self, from: data)
                DispatchQueue.main.async {
                    completion(pokemonDetailDTO)
                }
            } catch {
                print("Error decoding PokemonDetailDTO:", error)
            }
        }.resume()
    }
}

//class ImageAPI {
//    func getData(url: String, completion: @escaping (Data?) -> Void) {
//        guard let url = URL(string: url) else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                completion(data)
//            }
//        }.resume()
//    }
//}
