//
//  DireccionView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 25/2/25.
//

import SwiftUI

struct Address {
    let email: String
    let name: String
    let phone: String
    let street: String
    let streetNumber: Int
    let portal: String
    let postalCode: String
    let cityProvince: String
}

struct DireccionView: View {
    @State private var profileOpen = false
    
    // Creamos una dirección de ejemplo
    @State private var address = Address(
        email: "comotutellamas@gmail.com",
        name: "Hiromy",
        phone: "123456789",
        street: "Calle Falsa",
        streetNumber: 123,
        portal: "B",
        postalCode: "28080",
        cityProvince: "Madrid, España"
    )
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "arrow.left")
                }
                
                Text("Billing Addresses")
                    .font(.custom("Geist-Medium", size: 18))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "cart.fill")
                }
                
                Button {
                    profileOpen = true
                } label: {
                    Image(systemName: "person.circle.fill")
                }
                .sheet(isPresented: $profileOpen) {
                    ProfileView(isPresented: $profileOpen)
                        .presentationDetents([.medium, .large])
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
            
            VStack {
                DirectionItem(address: address)
                DirectionItem(address: address)
                DirectionItem(address: address)
                DirectionItem(address: address)
                Button {
                    
                }label: {
                    Text("add Direction")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(0)
        Spacer()
    }
}

#Preview {
    DireccionView()
}

