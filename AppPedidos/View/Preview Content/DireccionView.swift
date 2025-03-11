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

    init() {
        _adressManager = StateObject(wrappedValue: AdressManager(userEmail: ""))
    }
    var body: some View {
        NavigationView{
            VStack {
                    List(adressManager.adresses) { item in
                        DirectionItem(address: item, adressManager: adressManager)
                    }
                    .scrollContentBackground(.hidden)
                    Button {
                        Editing = true
                    }label: {
                        Text("add Direction")
                    }
                    .buttonStyle(.borderedProminent)

                NavigationLink(destination: EditAdressView(adressManager: adressManager, Adress: .init(email: "", name: "", phone: "", street: "", streetNumber: "", portal: "", postalCode: "", cityProvince: "")), isActive: $Editing) {
                    EmptyView()
                }
                .hidden()
            }
            .background(Color.white)
        }
        
    }
}

#Preview {
    DireccionView()
}

