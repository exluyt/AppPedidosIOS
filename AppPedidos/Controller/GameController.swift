//
//  GameController.swift
//  AppPedidos
//
//  @author: Arpad Kiss, Henry Illescas
//

import SwiftUI

class GameController {
    private let baseURL = "http://10.100.9.158:5000/buscar_app"
    
    // Ahora la función acepta una referencia a GameViewModel
    func fetchGames(appName: String = "", category: String = "", how: String = "", gameViewModel: GameViewModel) {
        var url: URL?
        
        if how == "buscar" || how == "strategy" {
            url = URL(string: "http://10.100.9.158:5000/buscar_app")
        } else if how == "top" {
            url = URL(string: "http://10.100.9.158:5000/info_app")
        }
        
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
                           let rating = gameData["Puntuacion"] as? Double,
                           let image = gameData["Imagenes"] as? [String],
                           //let headerIamge = gameData["HeaderImage"] as? String,
                           let firstImage = image.first {
                            let game = Game(name: name, rating: rating, image: firstImage, installed: false/*, headerImage: headerIamge*/)
                            gamesArray.append(game)
                        }
                    }
                    DispatchQueue.main.async {
                        if how == "buscar" {
                            gameViewModel.suggestedGames = gamesArray
                        } else if how == "top" {
                            gameViewModel.topGames = gamesArray
                        } else if how == "strategy" {
                            gameViewModel.strategyGames = gamesArray
                        }
                    }
                }
            } catch {
                print("Error al procesar los datos: \(error.localizedDescription)")
            }
        }.resume()
    }
}
