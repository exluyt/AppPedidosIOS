//
//  AdressManager.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//

import Foundation
struct AdressData: Codable {
    //todo
    let userEmail: String
    var adresses: [Adress]
}

class AdressManager: ObservableObject {
    @Published var adresses: [Adress] = []
    var userEmail: String
    private let fileName = "adress.json"

    init(userEmail: String) {
        self.userEmail = userEmail
        loadAdress()
    }

    private func getFilePath() -> URL? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return dir.appendingPathComponent(fileName)
    }

    // Función para guardar solo el carrito del usuario actual
    func saveAdress() {
        guard let fileURL = getFilePath() else { return }

        // Primero, cargamos todos los carritos
        var allAdress: [AdressData] = loadAllAdress()

        // Si ya existe un carrito para este userEmail, actualizamos su carrito
        if let index = allAdress.firstIndex(where: { $0.userEmail == userEmail }) {
            allAdress[index].adresses = adresses
        } else {
            // Si no existe, agregamos un nuevo carrito para el userEmail
            let newAdress = AdressData(userEmail: userEmail, adresses: adresses)
            allAdress.append(newAdress)
        }

        // Guardamos todos los carritos actualizados
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(allAdress)
            try data.write(to: fileURL)
            print("Direccion guardado correctamente en \(fileURL.path)")
        } catch {
            print("Error al guardar la direccion: \(error.localizedDescription)")
        }
        loadAdress()
    }

    // Función para cargar solo el carrito del usuario actual
    func loadAdress() {
        guard let fileURL = getFilePath() else { return }

        do {
            let data = try Data(contentsOf: fileURL)
            let allAdress = try JSONDecoder().decode([AdressData].self, from: data)

            // Buscamos el carrito asociado al userEmail actual
            if let existingAdress = allAdress.first(where: { $0.userEmail == userEmail }) {
                self.adresses = existingAdress.adresses
                print("Direccion cargado para \(userEmail).")
            } else {
                // Si no se encuentra un carrito, creamos uno vacío
                self.adresses = []
                print("No se encontró direccion para \(userEmail), se ha creado uno nuevo.")
            }
        } catch {
            print("Error al cargar el direccion: \(error.localizedDescription)")
        }
    } 

    // Función para cargar todos los carritos desde el archivo
    private func loadAllAdress() -> [AdressData] {
        guard let fileURL = getFilePath() else { return [] }

        do {
            let data = try Data(contentsOf: fileURL)
            let allAdress = try JSONDecoder().decode([AdressData].self, from: data)
            return allAdress
        } catch {
            print("Error al cargar todas lasa direccions: \(error.localizedDescription)")
            return []
        }
    }
    func addAdress(adress: Adress) {
        if let index = adresses.firstIndex(where: { $0.id == adress.id })
        {
            adresses[index] = adress
        }
        else
        {
            let newAdress = adress
            adresses.append(newAdress)
        }
        saveAdress()
    }
    // Función para actualizar el email y recargar el carrito para el nuevo email
    func updateEmail(_ newEmail: String) {
        if !newEmail.isEmpty {
            userEmail = newEmail
            loadAdress() 
        }
    }
}


