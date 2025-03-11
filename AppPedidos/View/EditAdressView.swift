//
//  EditAdressView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//

import SwiftUI

struct EditAdressView: View {
    @ObservedObject var adressManager: AdressManager
    @State var Adress: Adress
    var body: some View {
        
        VStack{
            TitleLine(title: "Personal Info")
            TField(value: $Adress.name, name: "Full name")
            TField(value: $Adress.phone, name: "Phone number")
            TitleLine(title: "Adress")
                
            TField(value: $Adress.cityProvince, name: "City / Province")
            TField(value: $Adress.street, name: "Street")
                HStack{
                    TField(value: $Adress.streetNumber, name:"Number")
                    TField(value: $Adress.portal, name: "Portal")
                    TField(value: $Adress.postalCode, name: "Postal Code")
                }
            Spacer()
            Button("Add direction") {
                adressManager.addAdress(adress: Adress)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
        .frame(width: UIScreen.main.bounds.width * 0.9)
    }
}
