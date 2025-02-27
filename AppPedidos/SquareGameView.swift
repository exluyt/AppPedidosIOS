//
//  SquareGameView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 27/2/25.
//

import SwiftUI

struct SquareGameView: View {
    var body: some View {
        let game:Game
        if game == nil
        VStack{
            // Cargar la imagen de manera asíncrona desde la URL
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
            
            // Nombre del juego
            Text(game.name)
                .font(.footnote)
                .frame(width: 100, height: 43, alignment: .topLeading)
            
            // Puntuación del juego
            HStack {
                Text(String(format: "%.1f", game.rating))
                    .font(.footnote)
                    .frame(alignment: .center)
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.footnote)
                    .frame(alignment: .center)
            }
            .frame(width:100, height: 20, alignment: .topLeading)
        }
    }
}

#Preview {
    SquareGameView()
}
