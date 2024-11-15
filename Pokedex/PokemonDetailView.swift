import SwiftUI

struct PokemonDetailView: View {
    let pokemon: PokemonModel
    //    @State var flavorText: String? = nil

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(
                    colors: pokemon.typeColors.count > 1
                        ? pokemon.typeColors
                        : [pokemon.typeColors.first ?? .red, .white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 20) {

                    // Pokemon Image Card

                    if let imageURL = pokemon.imageURL,
                        let url = URL(string: imageURL)
                    {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Text("No Image Available")
                            .font(.caption)
                    }

                    // Pokemon Info Card
                    ZStack {
                        Color.black
                            .opacity(0.8)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                            .frame(width: 300, height: 180)

                        VStack(spacing: 8) {
                            HStack {
                                Text("#\(pokemon.id)").font(.subheadline)
                                    .foregroundColor(.gray)
                                    .font(.title)
                                Text(pokemon.name.capitalized)
                                    .font(.system(size: 20, weight: .bold))
                                    .font(.headline).foregroundColor(.primary)
                                    .font(.largeTitle)

                            }.fixedSize()
                            HStack(spacing: 4) {
                                ForEach(pokemon.types) { type in

                                    Circle()
                                        .fill(type.color)
                                        .frame(width: 8, height: 8)
                                    Text(type.typeName.capitalized)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                            Text("Weight: \(pokemon.formattedWeight)")
                                .font(.body)
                                .foregroundColor(.white)

                            Text("Height: \(pokemon.formattedHeight)")
                                .font(.body)
                                .foregroundColor(.white)

                            Text("Type: \(pokemon.typeNames)")
                                .font(.body)
                                .foregroundColor(.white)

                        }
                        .foregroundColor(.black)
                        .padding()
                    }

                    // Stats Section
                    VStack(spacing: 15) {
                        Text("Stats")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)

                        ZStack {
                            Color.black
                                .opacity(0.8)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 10)
                                .frame(width: 330, height: 270)

                            VStack(spacing: 10) {
                                StatBarView(
                                    statName: "HP", value: pokemon.hp,
                                    barColor: .red
                                )
                                StatBarView(
                                    statName: "Att.", value: pokemon.attack,
                                    barColor: .orange
                                )
                                StatBarView(
                                    statName: "Def.", value: pokemon.defense,
                                    barColor: .yellow.opacity(0.8)
                                )
                                StatBarView(
                                    statName: "Sp. Att.",
                                    value: pokemon.specialAttack,
                                    barColor: .blue
                                )
                                StatBarView(
                                    statName: "Sp. Def",
                                    value: pokemon.specialDefense,
                                    barColor: .green
                                )
                                StatBarView(
                                    statName: "Speed", value: pokemon.speed,
                                    barColor: .purple
                                )
                            }
                            .padding()
                        }
                    }

                    Spacer()
                }
                .padding(.top, 80)

            }
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()  // Transparent background
                appearance.backgroundColor = .clear  // No color for background
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().standardAppearance = appearance
            }
        }
    }
    struct StatBarView: View {
        let statName: String
        let value: Int
        let barColor: Color

        var body: some View {
            HStack {
                Text("\(statName):")
                    .font(.body)
                    .frame(width: 80, alignment: .leading)

                ProgressView(value: Double(value), total: 200)
                    .progressViewStyle(LinearProgressViewStyle(tint: barColor))
                    .frame(width: 150, height: 20)

                Text("\(value)")
                    .font(.body)
                    .frame(width: 35, alignment: .trailing)
            }
        }
    }

}
