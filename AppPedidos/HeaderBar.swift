//
//  HeaderBar.swift
//  AppPedidos
//
//  Created by Usuario invitado on 25/2/25.
//

import SwiftUI

struct HeaderBar: View {
    @State private var profileOpen = false
    let title:String
    let search:Bool
    let cart:Bool
    let profile:Bool
    var body: some View {
        HStack{
            Text(title)
            Spacer()
            if(search){
                Button{
                    
                }label: {
                    Image(systemName: "magnifyingglass")
                }
            }
            if(cart){
                Button{
                }label: {
                    Image(systemName: "cart.fill")
                }
            }
            if(profile){
                Button{
                    profileOpen = true
                }label: {
                    Image(systemName: "person.circle.fill")
                }.sheet(isPresented: $profileOpen) {
                    ProfileView(isPresented: $profileOpen)
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
