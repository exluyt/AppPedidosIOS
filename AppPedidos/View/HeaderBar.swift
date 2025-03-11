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
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if search {
                Button {} label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            if cart {
                NavigationLink(destination: CartView(cartManager: cartManager)) {
                    Image(systemName: "cart.fill")
                }
            }
            if profile {
                if !isLoggedIn {
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
            ProfileView(isPresented: $profileOpen, mail: $email, isLoggedIn: $isLoggedIn)
                .presentationDetents([.medium, .large])
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

