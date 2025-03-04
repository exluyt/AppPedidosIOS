//
//  CartItem.swift
//  AppPedidos
//
//  Created by Usuario invitado on 4/3/25.
//


import Foundation

class CartManager: ObservableObject {
    @Published var cartGames: [Game] = []
    let userEmail: String
    let fileName = "cart.json"

    init(userEmail: String) {
        self.userEmail = userEmail
        loadCart()
    }

    private func getFilePath() -> URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let fileURL = dir.appendingPathComponent(fileName)
        print("Ruta del archivo JSON: \(fileURL.path)")
        return fileURL
    }

    func saveCart() {
        guard let fileURL = getFilePath() else { return }
        let cartData = [userEmail: cartGames]
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(cartData)
            try data.write(to: fileURL)
            print("Carrito guardado correctamente en \(fileURL.path)")
        } catch {
            print("Error al guardar el carrito: \(error.localizedDescription)")
        }
    }


    func loadCart() {
        guard let fileURL = getFilePath() else { return }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode([String: [Game]].self, from: data)
            self.cartGames = decodedData[userEmail] ?? []
        } catch {
            print("Error al cargar el carrito: \(error.localizedDescription)")
        }
    }

    func addGameToCart(game: Game) {
        if let index = cartGames.firstIndex(where: { $0.name == game.name }) {
            cartGames[index].installed.toggle() // Cambia el estado de instalación
        } else {
            var newGame = game
            newGame.installed = false  // Se añade con instalado en falso
            cartGames.append(newGame)
        }
        saveCart()
    }
}
