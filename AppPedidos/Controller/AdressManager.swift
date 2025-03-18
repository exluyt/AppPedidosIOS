//
//  AdressManager.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//

import Foundation

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

    // Función para guardar solo las direcciones del usuario actual
    func saveAdress() {
        guard let fileURL = getFilePath() else { return }

        // Primero, cargamos todas las direcciones
        var allAdress: [AdressData] = loadAllAdress()

        // Si ya existe una dirección para este userEmail, actualizamos sus direcciones
        if let index = allAdress.firstIndex(where: { $0.userEmail == userEmail }) {
            allAdress[index].adresses = adresses
        } else {
            // Si no existe, agregamos un nuevo objeto AdressData
            let newAdress = AdressData(userEmail: userEmail, adresses: adresses)
            allAdress.append(newAdress)
        }

        // Guardamos todas las direcciones actualizadas
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(allAdress)
            try data.write(to: fileURL)
            print("Dirección guardada correctamente en \(fileURL.path)")
        } catch {
            print("Error al guardar la dirección: \(error.localizedDescription)")
        }
        loadAdress()
    }

    // Función para cargar solo las direcciones del usuario actual
    func loadAdress() {
        guard let fileURL = getFilePath() else { return }

        do {
            let data = try Data(contentsOf: fileURL)
            let allAdress = try JSONDecoder().decode([AdressData].self, from: data)

            // Buscamos las direcciones asociadas al userEmail actual
            if let existingAdress = allAdress.first(where: { $0.userEmail == userEmail }) {
                self.adresses = existingAdress.adresses
                print("Dirección cargada para \(userEmail).")
            } else {
                // Si no se encuentra ninguna dirección, se crea una lista vacía
                self.adresses = []
                print("No se encontró dirección para \(userEmail), se ha creado uno nuevo.")
            }
        } catch {
            print("Error al cargar las direcciones: \(error.localizedDescription)")
        }
    }

    // Función para cargar todas las direcciones desde el archivo
    private func loadAllAdress() -> [AdressData] {
        guard let fileURL = getFilePath() else { return [] }

        do {
            let data = try Data(contentsOf: fileURL)
            let allAdress = try JSONDecoder().decode([AdressData].self, from: data)
            return allAdress
        } catch {
            print("Error al cargar todas las direcciones: \(error.localizedDescription)")
            return []
        }
    }

    func addAdress(adress: Adress) {
        if let index = adresses.firstIndex(where: { $0.id == adress.id }) {
            adresses[index] = adress
        } else {
            let newAdress = adress
            adresses.append(newAdress)
        }
        saveAdress()
    }

    // Función para actualizar el email y recargar las direcciones para el nuevo email
    func updateEmail(_ newEmail: String) {
        if !newEmail.isEmpty {
            userEmail = newEmail
            loadAdress()
        }
    }
}


