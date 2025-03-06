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
        loadCart()  // Cargamos el carrito al inicializar
    }

    private func getFilePath() -> URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return dir.appendingPathComponent(fileName)
    }

    // Función para guardar solo el carrito del usuario actual
    func saveCart() {
        guard let fileURL = getFilePath() else { return }

        // Primero, cargamos todos los carritos
        var allCarts: [CartData] = loadAllCarts()

        // Si ya existe un carrito para este userEmail, actualizamos su carrito
        if let index = allCarts.firstIndex(where: { $0.userEmail == userEmail }) {
            allCarts[index].cartGames = cartGames
        } else {
            // Si no existe, agregamos un nuevo carrito para el userEmail
            let newCart = CartData(userEmail: userEmail, cartGames: cartGames)
            allCarts.append(newCart)
        }

        // Guardamos todos los carritos actualizados
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(allCarts)
            try data.write(to: fileURL)
            print("Carrito guardado correctamente en \(fileURL.path)")
        } catch {
            print("Error al guardar el carrito: \(error.localizedDescription)")
        }
    }

    // Función para cargar solo el carrito del usuario actual
    func loadCart() {
        guard let fileURL = getFilePath() else { return }

        do {
            let data = try Data(contentsOf: fileURL)
            let allCarts = try JSONDecoder().decode([CartData].self, from: data)

            // Buscamos el carrito asociado al userEmail actual
            if let existingCart = allCarts.first(where: { $0.userEmail == userEmail }) {
                self.cartGames = existingCart.cartGames
                print("Carrito cargado para \(userEmail).")
            } else {
                // Si no se encuentra un carrito, creamos uno vacío
                self.cartGames = []
                print("No se encontró carrito para \(userEmail), se ha creado uno nuevo.")
            }
        } catch {
            print("Error al cargar el carrito: \(error.localizedDescription)")
        }
    }

    // Función para cargar todos los carritos desde el archivo
    private func loadAllCarts() -> [CartData] {
        guard let fileURL = getFilePath() else { return [] }

        do {
            let data = try Data(contentsOf: fileURL)
            let allCarts = try JSONDecoder().decode([CartData].self, from: data)
            return allCarts
        } catch {
            print("Error al cargar todos los carritos: \(error.localizedDescription)")
            return []
        }
    }

    // Función para agregar un juego al carrito
    func addGameToCart(game: Game) {
        if let index = cartGames.firstIndex(where: { $0.name == game.name }) {
            cartGames[index].installed.toggle()
        } else {
            var newGame = game
            newGame.installed = true
            cartGames.append(newGame)
        }
        saveCart() // Guardamos el carrito después de modificarlo
    }

    // Función para actualizar el email y recargar el carrito para el nuevo email
    func updateEmail(_ newEmail: String) {
        if !newEmail.isEmpty {
            userEmail = newEmail
            loadCart() // Recargamos el carrito para el nuevo email
        }
    }
}


