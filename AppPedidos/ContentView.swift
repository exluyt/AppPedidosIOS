//
//  ContentView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 6/2/25.
//

import SwiftUI

struct AppData: Codable {
    let Nombre: String
    let Desarrollador: String
    let Puntuación: Double?
    let Descargas: String
    let Descripción: String
    let Imagenes: [String]
}

struct ContentView: View {
    @State private var appData: AppData?
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            HStack {
                Text("Buscar App")
                
                Spacer()
                
                Button {
                    fetchAppInfo(appName: "WhatsApp")
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            .font(.custom("Geist-Black", size: 24))
            .padding(8)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black),
                alignment: .bottom
            )
            
            if let appData = appData {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Nombre: \(appData.Nombre)")
                        .font(.title2)
                    Text("Desarrollador: \(appData.Desarrollador)")
                        .font(.headline)
                    Text("Puntuación: \(appData.Puntuación ?? 0.0)")
                    Text("Descargas: \(appData.Descargas)")
                    Text("Descripción: \(appData.Descripción)")
                    
                    if let firstImage = appData.Imagenes.first, let url = URL(string: firstImage) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
    }
    
    func fetchAppInfo(appName: String) {
        guard let url = URL(string: "http://10.100.28.33:5000/buscar_app") else {
            errorMessage = "URL inválida"
            return
        }
        
        let requestBody: [String: Any] = ["app_name": appName]
        let jsonData = try? JSONSerialization.data(withJSONObject: requestBody)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    errorMessage = "Error en la conexión"
                }
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(AppData.self, from: data)
                DispatchQueue.main.async {
                    appData = decodedData
                    errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Error al procesar la respuesta"
                }
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
