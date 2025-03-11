//
//  EditAdressView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//

import SwiftUI

struct EditAdressView: View {

    @State var Adress: Adress
    var body: some View {
        
        VStack{
            TitleLine(title: "Personal Info")
            
                TField(value: $Adress.name)
                TField(value: $Adress.phone)
            
            .frame(width: UIScreen.main.bounds.width * 0.9)
            TitleLine(title: "Adress")
            Section{
                TField(value: $Adress.cityProvince)
                TField(value: $Adress.street)
                HStack{
                    TField(value: $Adress.streetNumber)
                    TField(value: $Adress.portal)
                    TField(value: $Adress.postalCode)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.9)
        }
        .frame(minHeight: 0, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    @Previewable @State var address = Adress(
        email: "comotutellamas@gmail.com",
        name: "Hiromy",
        phone: "123456789",
        street: "Calle Falsa",
        streetNumber: 123,
        portal: "B",
        postalCode: "28080",
        cityProvince: "Madrid, España"
    )
    EditAdressView(Adress: address)
}
