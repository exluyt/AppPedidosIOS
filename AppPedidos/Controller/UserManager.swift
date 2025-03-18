//
//  UserManager.swift
//  AppPedidos
//
//  @author: Arpad Kiss, Henry Illescas
//


import Foundation

class UserManager: ObservableObject {
    private let fileName = "user.json"
    
    private var fileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    // Modificado para manejar un array de usuarios
    func loadUser(email: String) -> User? {
        let fileURL = self.fileURL
        
        // Si el archivo no existe, crea un nuevo usuario
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            print("El archivo no existe, creando uno nuevo.")
            let defaultUser = User(email: email, username: "Default User")
            saveUser(email: defaultUser.email, username: defaultUser.username)
            return defaultUser
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let users = try decoder.decode([User].self, from: data)  // Decodificamos un array de usuarios
            
            // Busca el usuario con el email correspondiente
            if let user = users.first(where: { $0.email == email }) {
                return user
            } else {
                // Si no se encuentra el usuario, crea uno nuevo con ese email
                let newUser = User(email: email, username: "Default User")
                saveUser(email: newUser.email, username: newUser.username)
                return newUser
            }
        } catch {
            print("Error al cargar el archivo: \(error)")
            return nil
        }
    }
    
    // Guarda el usuario en una lista
    func saveUser(email: String, username: String) {
        let fileURL = self.fileURL
        let documentsDirectory = fileURL.deletingLastPathComponent()
        
        if !FileManager.default.fileExists(atPath: documentsDirectory.path) {
            do {
                try FileManager.default.createDirectory(at: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error al crear el directorio: \(error)")
                return
            }
        }
        
        var users = loadAllUsers()  // Cargar todos los usuarios
        if let index = users.firstIndex(where: { $0.email == email }) {
            users[index].username = username  // Actualiza el usuario existente
        } else {
            // Si no existe el usuario, lo agrega
            let newUser = User(email: email, username: username)
            users.append(newUser)
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(users)  // Guarda la lista de usuarios
            
            try data.write(to: fileURL)
        } catch {
            print("Error al guardar el archivo: \(error)")
        }
    }
    
    // Cargar todos los usuarios
    private func loadAllUsers() -> [User] {
        let fileURL = self.fileURL
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            return []
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode([User].self, from: data)  // Decodificamos una lista de usuarios
        } catch {
            print("Error al cargar los usuarios: \(error)")
            return []
        }
    }
}
