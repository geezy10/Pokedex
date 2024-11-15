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
    @State var selectedGen = 1
    @State var showGenSelector = false
    @Environment(\.modelContext) var modelContext
    let pokeAPI = PokeAPI()

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

                Button(action: {
                    showGenSelector = true
                }) {
                    Text("Select Generation: Gen \(selectedGen)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray).opacity(0.3)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }

                List(filteredPokemons) { pokemon in
                    NavigationLink(
                        destination: PokemonDetailView(pokemon: pokemon)
                    ) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                //first row
                                HStack {
                                    Text("#\(pokemon.id)").font(.subheadline)
                                        .foregroundColor(.gray)
                                    Text(pokemon.name.capitalized)
                                        .font(.headline).foregroundColor(
                                            .primary)
                                }
                                //second row
                                HStack(spacing: 4) {
                                    ForEach(pokemon.types) { type in
                                        HStack(spacing: 4) {
                                            Circle()
                                                .fill(type.color)
                                                .frame(width: 8, height: 8)
                                            Text(type.typeName.capitalized)
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                            Spacer()

                            //image on the right
                            if let imageURL = pokemon.imageURL,
                                let url = URL(string: imageURL)
                            {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Text("Image not available")
                                    .frame(width: 50, height: 50)
                            }
                        }
                        .padding(.vertical, 4)

                    }
                    .listRowSeparator(.hidden)

                }

            }

                }

            .sheet(isPresented: $showGenSelector) {
                GenerationSelectorView(
                    selectedGen: $selectedGen,
                    showGenerationSelector: $showGenSelector,
                    fetchfromAPI: fetchfromAPI)
            }
        }
    }

    private func fetchfromAPI() {

        for pokemon in pokemons {
            modelContext.delete(pokemon)
        }
        try? modelContext.save()

        print("Loading from API...")
        pokeAPI.getPokemons(forGeneration: selectedGen) { pokemonDTO in
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

                    // Map [TypeElement] to [TypeModel]
                    let typeModels = detailDTO.types.map { typeElement in
                        TypeModel(
                            slot: typeElement.slot,
                            typeName: typeElement.type.name
                        )
                    }

                    // Create PokemonModel with mapped statsModels
                    let pokemon = PokemonModel(
                        id: detailDTO.id,
                        name: pokemonDTO.name,
                        url: pokemonDTO.url,
                        imageURL: detailDTO.sprites.frontDefault ?? "",
                        weight: detailDTO.weight,
                        height: detailDTO.height,
                        stats: statsModels,
                        types: typeModels
                    )

                    DispatchQueue.main.async {
                        modelContext.insert(pokemon)  // Save to SwiftData
                        try? modelContext.save()
                        print(
                            "Inserted \(pokemon.name) with ID \(pokemon.id) into SwiftData"
                        )

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

    struct GenerationSelectorView: View {
        @Binding var selectedGen: Int
        @Binding var showGenerationSelector: Bool
        let fetchfromAPI: () -> Void

        var body: some View {
            VStack(spacing: 20) {
                ScrollView(.vertical, showsIndicators: false) {

                    Text("Select Pokémon Generation")
                        .font(.headline)
                        .padding()
                }
                ForEach(1...9, id: \.self) { gen in
                    Button(action: {
                        selectedGen = gen
                        showGenerationSelector = false
                        fetchfromAPI()
                    }) {
                        Text("Generation \(gen)")
                            .font(.title3)
                            .foregroundColor(
                                selectedGen == gen ? .white : .primary
                            )
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                selectedGen == gen
                                    ? Color.blue : Color.gray.opacity(0.2)
                            )
                            .cornerRadius(10)
                            .shadow(
                                color: selectedGen == gen
                                    ? .blue.opacity(0.3) : .clear, radius: 6,
                                x: 0, y: 3)
                    }
                }

                Button("Close") {
                    showGenerationSelector = false
                }
                .padding()
                .foregroundColor(.red)
            }
            .padding(10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        PokemonListView()
            .modelContainer(for: [
                PokemonModel.self, StatModel.self, TypeModel.self,
            ])
            .preferredColorScheme(.dark)
            .previewDisplayName("View List in Dark Mode")

    }
}
