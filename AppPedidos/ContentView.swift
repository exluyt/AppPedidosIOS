//
//  ContentView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 6/2/25.
//

import SwiftUI


// Estructura del juego con conformidad a Codable
struct Game: Identifiable, Codable {
    let id = UUID()  // ID único para cada juego
    let name: String
    let rating: Double
    let image: String
}

// Vista de modelo que maneja la lógica de los juegos
class GameViewModel: ObservableObject {
    @Published var games = [Game]()
    @Published var strategyGames = [Game]() // Para juegos de estrategia
    
    func fetchGames(appName: String = "", category: String = "") {
        guard let url = URL(string: "http://10.100.25.195:5000/buscar_app") else { return }
        
        // Si appName está vacío, no lo incluyes; si category tiene valor, lo incluyes
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
                // Asumiendo que la respuesta es un array de juegos
                if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    var gamesArray: [Game] = []
                    for gameData in responseArray {
                        // Crear un objeto de tipo Game desde los datos de la respuesta
                        if let name = gameData["Nombre"] as? String,
                           let rating = gameData["Puntuación"] as? Double,
                           let image = gameData["Imagenes"] as? [String],
                           let firstImage = image.first {
                            let game = Game(name: name, rating: rating, image: firstImage)
                            gamesArray.append(game)
                        }
                    }
                    DispatchQueue.main.async {
                        if category.isEmpty {
                            self.games = gamesArray // Juegos sin categoría
                        } else {
                            self.strategyGames = gamesArray // Juegos de categoría "strategy"
                        }
                    }
                }
            }
        }.resume()
    }
}


struct ContentView: View {
    @State private var isProfilePresented = false
    @State private var title = "LootBox Store"
    @StateObject var viewModel = GameViewModel()
    @State var isLoggedIn = false
    @State var email = ""
    var body: some View {
        
        NavigationView{
            VStack {
                HeaderBar(email: email, isLoggedIn: $isLoggedIn, title: title, search: true, cart: true, profile: true)
                
                
                TitleLine(title:"Top Apps")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.games) { game in
                            GameView(game: game)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                TitleLine(title:"Suggestions for you")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.games) { game in
                            GameRow(game: game)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
                
                TitleLine(title:"Strategy")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.strategyGames) { game in
                            GameRow(game: game)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                viewModel.fetchGames(appName: "")  // Cargar juegos sin categoría para "Suggestions for you"
                viewModel.fetchGames(category: "strategy")  // Cargar juegos de la categoría "strategy"
            }
            .padding(0)
            
        }

        
    }
}

// Vista para mostrar cada fila de un juego
struct GameRow: View {
    let game: Game

    var body: some View {
        VStack {
            // Cargar la imagen de manera asíncrona desde la URL
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
        
            Text(game.name)
                .font(.footnote)
                .frame(width: 100, height: 43, alignment: .topLeading)
            
            // Puntuación del juego
            HStack {
                Text(String(format: "%.1f", game.rating))
                    .font(.footnote)
                    .frame(alignment: .center)
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.footnote)
                    .frame(alignment: .center)
            }
            .frame(width:100, height: 20, alignment: .topLeading)
        }
    }
}

struct GameView: View {
    let game: Game
    
    var body: some View {
        VStack {
            // Header Image
            AsyncImage(url: URL(string: game.image)) { phase in
                switch phase {
                case .empty:
                    // Placeholder mientras se carga la imagen
                    Image(systemName: "gamecontroller")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .clipped()
                case .success(let image):
                    // Imagen cargada con éxito
                    image.resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: 200)
                        .clipped()
                case .failure:
                    // Error al cargar la imagen
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: 200)
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
