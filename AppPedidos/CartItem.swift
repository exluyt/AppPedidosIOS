//
//  CartItem.swift
//  AppPedidos
//
//  Created by Usuario invitado on 4/3/25.
//


import Foundation

struct CartData: Codable {
    let userEmail: String
    var cartGames: [Game]
}

class CartManager: ObservableObject {
    @Published var cartGames: [Game] = []
    var userEmail: String
    private let fileName = "cart.json"

    init(userEmail: String) {
        self.userEmail = userEmail
    }

    private func getFilePath() -> URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return dir.appendingPathComponent(fileName)
    }

    func saveCart() {
        guard let fileURL = getFilePath() else { return }

        let cartData = CartData(userEmail: userEmail, cartGames: cartGames)

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
            let decodedData = try JSONDecoder().decode(CartData.self, from: data)

            if decodedData.userEmail == userEmail {
                self.cartGames = decodedData.cartGames
            } else {
                self.cartGames = []
                print("No se encontró carrito para este email.")
            }
        } catch {
            print("Error al cargar el carrito: \(error.localizedDescription)")
        }
    }

    func addGameToCart(game: Game) {
        if let index = cartGames.firstIndex(where: { $0.name == game.name }) {
            cartGames[index].installed.toggle()
        } else {
            var newGame = game
            newGame.installed = true
            cartGames.append(newGame)
        }
        saveCart()
    }

    func updateEmail(_ newEmail: String) {
        if !newEmail.isEmpty {
            userEmail = newEmail
        }
    }
}

