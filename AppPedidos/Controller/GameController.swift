//
//  GameController.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//

import SwiftUI

class GameController {
    private let baseURL = "http://10.100.28.160:5000/buscar_app"

    func fetchGames(appName: String = "", category: String = "", completion: @escaping ([Game]) -> Void) {
        guard let url = URL(string: baseURL) else {
            print("URL inválida")
            return
        }

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
            print("Error al crear el JSON: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la solicitud: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let data = data else {
                print("No hay datos en la respuesta")
                completion([])
                return
            }

            do {
                // Verifica el contenido de la respuesta antes de intentar parsearlo
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Respuesta de la API: \(responseString)")  // Imprimir respuesta cruda
                }

                if let responseArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print("Respuesta JSON decodificada: \(responseArray)") // Verifica si la respuesta es un arreglo de diccionarios

                    let gamesArray = responseArray.compactMap { gameData -> Game? in
                        guard let name = gameData["Nombre"] as? String,
                              let rating = gameData["Puntuacion"] as? Double,
                              let image = gameData["Imagenes"] as? [String],
                              let firstImage = image.first else {
                            print("Error al parsear un juego: \(gameData)")
                            return nil
                        }
                        return Game(name: name, rating: rating, image: firstImage, installed: false)
                    }
                    
                    print("Juegos procesados: \(gamesArray)")  // Imprimir juegos procesados

                    DispatchQueue.main.async {
                        completion(gamesArray)
                    }
                } else {
                    print("La respuesta no es un arreglo de diccionarios")
                    completion([])
                }
            } catch {
                print("Error al parsear JSON: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
}
