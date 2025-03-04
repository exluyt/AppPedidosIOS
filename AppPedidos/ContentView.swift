//
//  ContentView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 6/2/25.
//

import SwiftUI


import SwiftUI

// Estructura del juego con conformidad a Codable
struct Game: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let rating: Double
    let image: String
    var installed: Bool // Nuevo estado de instalación
}

// Vista de modelo que maneja la lógica de los juegos
class GameViewModel: ObservableObject {
    @Published var games = [Game]()
    @Published var strategyGames = [Game]() // Para juegos de estrategia
    
    func fetchGames(appName: String = "", category: String = "") {
        guard let url = URL(string: "http://10.100.24.95:5000/buscar_app") else { return }
        
        var parameters: [String: Any] = ["app_name": appName, "n_hits": 10]
        if !category.isEmpty {
            parameters["category"] = category
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error al crear el JSON")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la solicitud: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var gamesArray: [Game] = []
                    for gameData in responseArray {
                        if let name = gameData["Nombre"] as? String,
                           let rating = gameData["Puntuación"] as? Double,
                           let image = gameData["Imagenes"] as? [String],
                           let firstImage = image.first {
                            let game = Game(name: name, rating: rating, image: firstImage, installed: false)
                            gamesArray.append(game)
                        }
                    }
                    DispatchQueue.main.async {
                        if category.isEmpty {
                            self.games = gamesArray
                        } else {
                            self.strategyGames = gamesArray
                        }
                    }
                }
            }
        }.resume()
    }
}


struct ContentView: View {
    @State private var isProfilePresented = false
    @StateObject var viewModel = GameViewModel()
    @State var isLoggedIn = false
    @State var email = ""
    let cartManager: CartManager

    init(email: String) {
        self.cartManager = CartManager(userEmail: email)  // 
    }

    var body: some View {
        NavigationView {
            VStack {
                HeaderBar(cartManager: cartManager, email: email, isLoggedIn: $isLoggedIn, title: "LootBox Store", search: true, cart: true, profile: true)
                TitleLine(title: "Suggestions for you")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.games) { game in
                            GameRow(game: game, cartManager: cartManager)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)

                TitleLine(title: "Strategy")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.strategyGames) { game in
                            GameRow(game: game, cartManager: cartManager)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .onAppear {
                viewModel.fetchGames(appName: "")
                viewModel.fetchGames(category: "strategy")
            }
        }
    }
}

// Vista para mostrar cada fila de un juego
struct GameRow: View {
    let game: Game
    @ObservedObject var cartManager: CartManager

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: game.image)) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "gamecontroller")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                case .success(let image):
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                case .failure:
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(game.name)
                .font(.footnote)
                .frame(width: 100, height: 43, alignment: .topLeading)
            
            HStack {
                Text(String(format: "%.1f", game.rating))
                    .font(.footnote)
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.footnote)
            }
            .frame(width: 100, height: 20, alignment: .topLeading)
            
            Button(action: {
                cartManager.addGameToCart(game: game)
            }) {
                HStack {
                    Image(systemName: cartManager.cartGames.contains(where: { $0.name == game.name }) ? "checkmark.circle.fill" : "cart.badge.plus")
                    Text(cartManager.cartGames.contains(where: { $0.name == game.name }) ? "Instalado" : "Añadir")
                }
                .font(.footnote)
                .padding(5)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
