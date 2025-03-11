//
//  TField.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//

import SwiftUI

struct TField: View {
    @Binding var value:String;
    var body: some View {
        TextField("", text: $value)
            .frame(height: 50)
            .keyboardType(.emailAddress)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color("Gray")))
            .foregroundColor(Color.white)
            .autocapitalization(.none)
    }
}
