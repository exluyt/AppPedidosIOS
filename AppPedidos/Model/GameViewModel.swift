//
//  GameViewModel.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var strategyGames: [Game] = []
    
    private var gameController = GameController()

    func loadGames() {
        gameController.fetchGames(how: "buscar", gameViewModel: self)
    }
    
    func loadStrategyGames() {
        gameController.fetchGames(appName: "", category: "Strategy", how: "buscar", gameViewModel: self)
    }
    
    func loadTopGames() {
        gameController.fetchGames(how: "top", gameViewModel: self)
    }
}
