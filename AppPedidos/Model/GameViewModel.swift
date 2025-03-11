//
//  GameViewModel.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var games = [Game]()
    @Published var strategyGames = [Game]()
    
    private let gameController = GameController()

    func loadGames() {
        gameController.fetchGames { [weak self] games in
            DispatchQueue.main.async {
                self?.games = games
            }
        }
    }
    
    func loadStrategyGames() {
        gameController.fetchGames(category: "strategy") { [weak self] games in
            DispatchQueue.main.async {
                self?.strategyGames = games
            }
        }
    }
}
