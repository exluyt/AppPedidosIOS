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
    var installed: Bool
    var headerImage: String
}

// Vista de modelo que maneja la lógica de los juegos
class GameViewModel: ObservableObject {
    @Published var games = [Game]()
    @Published var strategyGames = [Game]() // Para juegos de estrategia
    
    func fetchGames(appName: String = "", category: String = "", how: String = "") {
        // Declarar url antes de los bloques if
        var url: URL?
        
        if how == "buscar" {
            url = URL(string: "http://10.100.25.195:5000/buscar_app")
        } else if how == "top" {
            url = URL(string: "http://10.100.25.195:5000/info_app")
        }
        
        // Asegurarse de que url no sea nil antes de continuar
        guard let validUrl = url else {
            print("URL no válida")
            return
        }
        
        var parameters: [String: Any] = ["app_name": appName, "n_hits": 10]
        
        if !category.isEmpty {
            parameters["category"] = category
        }
        
        if how == "top" {
            parameters["app_names"] = ["Among US", "Bullet Echo", "Roblox", "JCC Pokemon Pocket", "Wild Rift"]
        }
        
        var request = URLRequest(url: validUrl)
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
                           let headerIamge = gameData["HeaderImage"] as? String,
                           let firstImage = image.first {
                            let game = Game(name: name, rating: rating, image: firstImage, installed: false, headerImage: headerIamge)
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
        @StateObject var cartManager: CartManager
        
        init() {
            _cartManager = StateObject(wrappedValue: CartManager(userEmail: ""))
        }
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        HeaderBar(cartManager: cartManager, email: $email, isLoggedIn: $isLoggedIn, title: "LootBox Store", search: true, cart: true, profile: true)
                        
                        TitleLine(title: "Top Games")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.games) { game in
                                    GameView(game: game, cartManager: cartManager)
                                }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width)
                        
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
                        if !email.isEmpty {
                            cartManager.updateEmail(email)
                        }
                        viewModel.fetchGames(appName: "", how: "buscar")
                        viewModel.fetchGames(category: "strategy", how: "buscar")
                        viewModel.fetchGames(how: "top")
                    }
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
    
    struct GameView: View {
        let game: Game
        @ObservedObject var cartManager: CartManager
        
        var body: some View {
            VStack {
                // Header Image
                AsyncImage(url: URL(string: game.headerImage)) { phase in
                    switch phase {
                    case .empty:
                        // Placeholder mientras se carga la imagen
                        Image(systemName: "gamecontroller")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            .clipped()
                    case .success(let image):
                        // Imagen cargada con éxito
                        image.resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            .clipped()
                    case .failure:
                        // Error al cargar la imagen
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                            .clipped()
                    @unknown default:
                        EmptyView()
                    }
                }
                
                // Game Info Section
                HStack(spacing: 20) {
                    // Game Image
                    AsyncImage(url: URL(string: game.image)) { phase in
                        switch phase {
                        case .empty:
                            // Placeholder mientras se carga la imagen
                            Image(systemName: "gamecontroller")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        case .success(let image):
                            // Imagen cargada con éxito
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        case .failure:
                            // Error al cargar la imagen
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        // Game Title
                        Text(game.name)
                            .font(.system(size: 18, weight: .semibold))
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        // Game Categories (Si tienes categorías en el juego, añádelas aquí)
                        Text("Action, Adventure") // Puedes reemplazar esto con categorías dinámicas si están disponibles
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                        
                        HStack {
                            // Rating
                            Text(String(format: "%.1f", game.rating))
                                .font(.system(size: 14, weight: .regular))
                            
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .frame(width: 20, height: 20)
                            
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
                        .padding(.top, 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(5)
            }
            .padding(15)
        }
    }

#Preview {
    ContentView()
}

