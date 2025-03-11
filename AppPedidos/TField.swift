//
//  TField.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//

import SwiftUI

struct TField: View {
    @Binding var value:String;
    var name = ""
    var body: some View {
        VStack{
            if (name != "")
            {
                Text(name)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .frame(height: 10)
            }
            TextField("", text: $value)
                .frame(height: 50)
                .keyboardType(.emailAddress)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color("Gray")))
                .foregroundColor(Color.white)
                .autocapitalization(.none)
        }
    }
}
