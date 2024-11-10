//
//  ContentView.swift
//  Pokedex
//
//  Created by Niklas gottlieb on 01.11.24.
//

import SwiftData
import SwiftUI

struct PokemonListView: View {

    @Query(sort: \PokemonModel.id) var pokemons: [PokemonModel]
    @State var searchText = ""
    @State private var dataLoaded = false
    @Environment(\.modelContext) var modelContext
    let pokeAPI = PokeAPI()
//    let imageAPI = ImageAPI()

    var body: some View {

        NavigationView {
            VStack {
                if let uiImage = UIImage(named: "PokeLogo") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 100)
                }

                TextField("Search Pokemon", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 5)

                List(filteredPokemons) { pokemon in
                    NavigationLink(
                        destination: PokemonDetailView(pokemon: pokemon)
                    ) {
                        HStack {
                            if let imageURL = pokemon.imageURL,
                                let url = URL(string: imageURL)
                            {
                                Text("#\(pokemon.id)")
                                Text(pokemon.name.capitalized)
                                Spacer()
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    Text("Loading...")
                                }
                            } else {
                                Text("Image not available")
                            }
                        }
                    }
                }
                .onAppear {
                    print("pokemons count in SwiftData: \(pokemons.count)")
                    if pokemons.isEmpty {
                        fetchfromAPI()
                    } else {
                        print("Loaded from local storage")
                    }
                }
            }
        }
    }

    private func fetchfromAPI() {
        print("Loading from API...")
        pokeAPI.getPokemons { pokemonDTO in
            if !pokemons.contains(where: { $0.name == pokemonDTO.name }) {
                pokeAPI.getDetail(url: pokemonDTO.url) { detailDTO in
                    // Map [Stat] to [StatModel]
                    let statsModels = detailDTO.stats.map { stat in
                        StatModel(
                            baseStat: stat.baseStat,
                            effort: stat.effort,
                            statName: stat.stat.name
                        )
                    }

//                    // Map [TypeElement] to [TypeModel]
//                    let typeModels = detailDTO.types.map { typeElement in
//                        TypeModel(
//                            slot: typeElement.slot,
//                            typeName: typeElement.type.name
//                        )
//                    }

                    // Create PokemonModel with mapped statsModels
                    let pokemon = PokemonModel(
                        id: detailDTO.id,
                        name: pokemonDTO.name,
                        url: pokemonDTO.url,
                        imageURL: detailDTO.sprites.frontDefault ?? "",
                        weight: detailDTO.weight,
                        height: detailDTO.height,
                        stats: statsModels
//                        ,types: typeModels
                    )

                    DispatchQueue.main.async {
                        modelContext.insert(pokemon)  // Save to SwiftData
                        print(
                            "Inserted \(pokemon.name) with ID \(pokemon.id) into SwiftData"
                        )
                        dataLoaded = true
                    }
                }
            }
        }
    }

    var filteredPokemons: [PokemonModel] {
        if searchText.isEmpty {
            return pokemons  // Return sorted list if no search text
        } else {
            return pokemons.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        PokemonListView()
            .modelContainer(for: [PokemonModel.self])
            .preferredColorScheme(.dark)
            .previewDisplayName("View List in Dark Mode")

    }
}
