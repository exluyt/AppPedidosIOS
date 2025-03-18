//
//  DireccionView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 25/2/25.
//

import SwiftUI
	
struct DireccionView: View {
    @State private var Editing = false
    @State private var profileOpen = false
    @StateObject var adressManager: AdressManager
    var userEmail: String

    init(userEmail: String) {
        _adressManager = StateObject(wrappedValue: AdressManager(userEmail: userEmail))
        self.userEmail = userEmail
    }

    var body: some View {
        NavigationView {
            VStack {
                List(adressManager.adresses) { item in
                    DirectionItem(address: item, adressManager: adressManager)
                }
                .scrollContentBackground(.hidden)
                
                Button {
                    Editing = true
                } label: {
                    Text("Add Direction")
                        .padding()
                        .font(.title2)
                }
                .buttonStyle(.borderedProminent)
                
                // NavigationLink explícito para la edición de dirección
                NavigationLink(
                    destination: EditAdressView(
                        adressManager: adressManager,
                        Adress: .init(email: userEmail, name: "", phone: "", street: "", streetNumber: "", portal: "", postalCode: "", cityProvince: "")
                    ),
                    isActive: $Editing
                ) {
                    EmptyView() // Este contenedor vacío maneja la navegación cuando Editing es verdadero
                }
                .hidden() // El NavigationLink ahora está oculto, pero funcional
            }
            .background(Color.white)
        }
    }
}
