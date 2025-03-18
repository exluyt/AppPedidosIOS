//
//  GameView.swift
//  AppPedidos
//
//  @author: Arpad Kiss, Henry Illescas
//

import SwiftUI

struct GameView: View {
    let game: Game
    @ObservedObject var cartManager: CartManager
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            // Header Image
            /*AsyncImage(url: URL(string: game.headerImage)) { phase in
                switch phase {
                case .empty:
                    // Placeholder mientras se carga la imagen
                    Image(systemName: "gamecontroller")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                        .clipped()
                case .success(let image):
                    // Imagen cargada con éxito
                    image.resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                        .clipped()
                case .failure:
                    // Error al cargar la imagen
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
                        .clipped()
                @unknown default:
                    EmptyView()
                }
            }*/
            
            // Game Info Section
            HStack(spacing: 20) {
                // Game Image
                AsyncImage(url: URL(string: game.image)) { phase in
                    switch phase {
                    case .empty:
                        // Placeholder mientras se carga la imagen
                        Image(systemName: "gamecontroller")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        // Imagen cargada con éxito
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    case .failure:
                        // Error al cargar la imagen
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    // Game Title
                    Text(game.name)
                        .font(.system(size: 18, weight: .semibold))
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    // Game Categories (Si tienes categorías en el juego, añádelas aquí)
                    Text("Action, Adventure") // Puedes reemplazar esto con categorías dinámicas si están disponibles
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    
                    HStack {
                        // Rating
                        Text(String(format: "%.1f", game.rating))
                            .font(.system(size: 14, weight: .regular))
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .frame(width: 20, height: 20)
                        
                        Button(action: {
                            cartManager.addGameToCart(game: game)
                        }) {
                            HStack {
                                Image(systemName: cartManager.cartGames.contains(where: { $0.name == game.name }) ? "checkmark.circle.fill" : "cart.badge.plus")
                                Text(cartManager.cartGames.contains(where: { $0.name == game.name }) ? "Instalado" : "Añadir")
                            }
                            .font(.footnote)
                            .padding(5)
                            .background(isLoggedIn ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .disabled(!isLoggedIn)
                    }
                    .padding(.top, 5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(5)
        }
        .padding(15)
    }
}
