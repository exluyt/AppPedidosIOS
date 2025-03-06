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

