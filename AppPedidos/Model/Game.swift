//
//  Game.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//

import SwiftUI

// Estructura del juego con conformidad a Codable
struct Game: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let rating: Double
    let image: String
    var installed: Bool
}

struct GameTop: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let rating: Double
    let image: String
    var installed: Bool
    var headerImage: String
}
