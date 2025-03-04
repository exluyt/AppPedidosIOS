//
//  CartView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 4/3/25.
//


import SwiftUI

struct CartView: View {
    @ObservedObject var cartManager: CartManager

    var body: some View {
        VStack {
            Text("Carrito de compras")
                .font(.largeTitle)
                .padding()

            if cartManager.cartGames.isEmpty {
                Text("Tu carrito está vacío")
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
                            Text("Estado: \(item.installed ? "Instalado" : "No instalado")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            cartManager.addGameToCart(game: item)
                        }) {
                            Text(item.installed ? "Desinstalar" : "Instalar")
                                .padding(8)
                                .background(item.installed ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .navigationTitle("Carrito")
    }
}
