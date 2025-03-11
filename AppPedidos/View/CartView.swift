//
//  CartView.swift
//  AppPedidos
//
//  @author: Arpad Kiss, Henry Illescas
//


import SwiftUI

struct CartView: View {
    @ObservedObject var cartManager: CartManager
    
    var body: some View {
        VStack {
            Text("All your games")
                .font(.largeTitle)
                .padding()
            
            if cartManager.cartGames.isEmpty {
                Text("You don't have games")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(cartManager.cartGames) { item in
                    HStack {
                        AsyncImage(url: URL(string: item.image)) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text("Estado: \(item.installed ? "Installed" : "Not installed")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            cartManager.addGameToCart(game: item)
                        }) {
                            Text(item.installed ? "Desinstall" : "Install")
                                .padding(8)
                                .background(item.installed ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .navigationTitle("Your Games")
    }
}
