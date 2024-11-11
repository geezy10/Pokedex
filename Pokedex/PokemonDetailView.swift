import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonModel

    var body: some View {
        ZStack {

            if let uiImage = UIImage(named: "pokedexBackground") {
                Image(uiImage: uiImage)
                    .resizable()
                    .ignoresSafeArea()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)

            }
            ScrollView {
                VStack {
                    ZStack {
                        Color.white
                            .opacity(0.7)
                            .frame(width: 250, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        HStack {
                            Text("# \(pokemon.id)")
                                .font(.title)

                            Text("\(pokemon.name.capitalized)")
                                .font(.title)

                        }
                    }
                    .padding(.top, 5)
                    
                    ZStack {
                        Color.white
                            .opacity(0.7)
                            .frame(width: 250, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        if let imageURL = pokemon.imageURL,
                            let url = URL(string: imageURL)
                        {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                            } placeholder: {
                                ProgressView()
                            }
                        } else {  //end of let
                            Text("No Image Available")
                                .font(.caption)
                        }  //end of else
                    }  //end of zstack img
                    .padding(.top, 5)
                    
                    ZStack{
                        Color.white
                            .opacity(0.7)
                            .frame(width: 250, height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        VStack{
                            let weight = Double(pokemon.weight) / 10
                            let fWeight = String(format: "%.1f", weight)
                            
                            let height = Double(pokemon.height) / 10
                            let fHeight = String(format: "%.1f", height)
                            
                            Text("Weight: \(fWeight) kg")
                                .font(.title3)
                            
                            Text("Height: \(fHeight) m")
                                .font(.title3)
                            
                            Text("Type: \(pokemon.typeNames)")
                                .font(.title3)
                        }
                    }
                    .padding(.top, 12)
                    
                    ZStack {
                        Color.white
                            .opacity(0.7)
                            .frame(width: 330, height: 270)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        VStack(alignment: .leading, spacing: 15) {
                            StatBarView(
                                statName: "HP", value: pokemon.hp,
                                barColor: .red)
                            StatBarView(
                                statName: "Att.", value: pokemon.attack,
                                barColor: .orange)
                            StatBarView(
                                statName: "Def.", value: pokemon.defense,
                                barColor: .yellow)
                            StatBarView(
                                statName: "Sp. Att.",
                                value: pokemon.specialAttack, barColor: .blue)
                            StatBarView(
                                statName: "Sp. Def",
                                value: pokemon.specialDefense, barColor: .green)
                            StatBarView(
                                statName: "Speed", value: pokemon.speed,
                                barColor: .pink)
                        }
                        
                    }  //end of zstack stats
                    .padding(.top, 5)
                    
                    Spacer()
                }  // end of main vstack containing stats image and else
            }  //end of background zstack
        }  // end of scroll view
    }  // end of some view
}  // end of detail view struct

struct StatBarView: View {
    let statName: String
    let value: Int
    let barColor: Color

    var body: some View {
        HStack {
            Text("\(statName):")
                .font(.title2)
                .frame(width: 100, alignment: .leading)

            ProgressView(value: Double(value), total: 255)
                .progressViewStyle(LinearProgressViewStyle(tint: barColor))
                .frame(width: 120, height: 20)

            Text("\(value)")
                .font(.caption)
                .frame(width: 35, alignment: .trailing)
        }
    }
}

#Preview {
    let samplePokemon = PokemonModel(
        id: 1,
        name: "bulbasaur",
        url: "https://pokeapi.co/api/v2/pokemon/1",
        imageURL:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
        weight: 69,
        height: 7,
        stats: [
            StatModel(baseStat: 45, effort: 0, statName: "hp"),
            StatModel(baseStat: 49, effort: 0, statName: "attack"),
            StatModel(baseStat: 49, effort: 0, statName: "defense"),
            StatModel(baseStat: 65, effort: 0, statName: "special-attack"),
            StatModel(baseStat: 65, effort: 0, statName: "special-defense"),
            StatModel(baseStat: 45, effort: 0, statName: "speed"),
        ],
        types: [
            TypeModel(slot: 1, typeName: "grass"),
            TypeModel(slot: 2, typeName: "poison"),
        ]
    )
    PokemonDetailView(pokemon: samplePokemon)
}
