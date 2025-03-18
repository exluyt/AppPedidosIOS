//
//  HeaderBar.swift
//  AppPedidos
//
//  @author: Arpad Kiss, Henry Illescas
//

import SwiftUI

struct HeaderBar: View {
    @ObservedObject var cartManager: CartManager
    @State private var profileOpen = false
    @Binding var email: String
    @Binding var isLoggedIn: Bool
    let title: String
    let search: Bool
    let cart: Bool
    let profile: Bool
    
    @StateObject var userManager = UserManager()
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            
            // Botón de búsqueda
            if search {
            }
            
            // Botón de carrito
            if cart {
                if !isLoggedIn {
                    // Si no está logueado, no mostrar el carrito
                } else {
                    NavigationLink(destination: CartView(cartManager: cartManager)) {
                        Image(systemName: "cart.fill")
                    }
                }
            }
            
            // Botón de perfil
            if profile {
                if !isLoggedIn {
                    // Si no está logueado, mostrar el botón de login
                    NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn, email: $email)) {
                        Image(systemName: "person.circle.fill")
                    }
                } else {
                    Button {
                        profileOpen.toggle()
                    } label: {
                        Image(systemName: "person.circle.fill")
                    }
                }
            }
        }
        .sheet(isPresented: $profileOpen) {
            // Usar el UserManager para cargar el usuario
            if let user = userManager.loadUser(email: email) {
                // Envolvemos ProfileView en un NavigationView para la navegación
                NavigationView {
                    ProfileView(isPresented: $profileOpen, mail: $email, isLoggedIn: $isLoggedIn)
                        .navigationBarTitle("Profile", displayMode: .inline) // Título en la barra de navegación
                        .presentationDetents([.medium, .large])
                }
            }
        }
        .font(.custom("Geist-Black", size: 24))
        .accentColor(Color.black)
        .padding(8)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black),
            alignment: .bottom
        )
    }
}
