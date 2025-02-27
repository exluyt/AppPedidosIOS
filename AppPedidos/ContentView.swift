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
        guard let url = URL(string: "http://10.100.28.112:5000/buscar_app") else { return }
        
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

// Vista principal donde se muestran los juegos
struct MainView: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationStack {
            if !isLoggedIn {
                ContentView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}

struct ContentView: View {
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("PlaceHolder")
                
                Spacer()
                Button {
                    // Acción de búsqueda
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                
                Button {
                    // Acción de carrito
                } label: {
                    Image(systemName: "cart.fill")
                }
                
                Button {
                    // Acción de perfil
                } label: {
                    Image(systemName: "person.circle.fill")
                }
                
            }
            .font(.custom("Geist-Black", size: 24))
            .accentColor(Color.black)
            .padding(8)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black),
                alignment: .bottom
            )
            
            // "Suggestions for you"
            Section {
                Text("Suggestions for you")
                    .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.black),
                        alignment: .bottom
                    )
                    .font(.custom("Geist-Medium", size: 20))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.games) { game in
                            GameRow(game: game)
                                .padding()
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.9)
            }
            
            // "Strategy"
            Text("Strategy")
                .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.black),
                    alignment: .bottom
                )
                .font(.custom("Geist-Medium", size: 20))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.strategyGames) { game in
                        GameRow(game: game)
                            .padding()
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
        }
        .onAppear {
            viewModel.fetchGames(appName: "")  // Cargar juegos sin categoría para "Suggestions for you"
            viewModel.fetchGames(category: "strategy")  // Cargar juegos de la categoría "strategy"
        }
        .padding(0)
        Spacer()
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
            
            // Nombre del juego
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


#Preview {
    ContentView()
}
