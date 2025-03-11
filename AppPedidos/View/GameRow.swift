//
//  GameRow.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//

import SwiftUI
// Vista para mostrar cada fila de un juego
struct GameRow: View {
    let game: Game
    @ObservedObject var cartManager: CartManager

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: game.image)) { phase in
                switch phase {
                case .empty:
                    Image(systemName: "gamecontroller")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                case .success(let image):
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                case .failure:
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(game.name)
                .font(.footnote)
                .frame(width: 100, height: 43, alignment: .topLeading)
            
            HStack {
                Text(String(format: "%.1f", game.rating))
                    .font(.footnote)
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.footnote)
            }
            .frame(width: 100, height: 20, alignment: .topLeading)
            
            Button(action: {
                cartManager.addGameToCart(game: game)
            }) {
                HStack {
                    Image(systemName: cartManager.cartGames.contains(where: { $0.name == game.name }) ? "checkmark.circle.fill" : "cart.badge.plus")
                    Text(cartManager.cartGames.contains(where: { $0.name == game.name }) ? "Instalado" : "Añadir")
                }
                .font(.footnote)
                .padding(5)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}
