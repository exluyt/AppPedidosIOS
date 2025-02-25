//
//  DireccionView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 25/2/25.
//

import SwiftUI

struct DireccionView: View {
    @State private var profileOpen = false
    var body: some View {
        VStack{
            HStack{
                Button (){
                    
                }label: {
                    Image(systemName: "arrow.left")
                }
                Text("Billings Addreses")
                    .font(.custom("Geist-medium", size: 18))
                Spacer()
                Button{
                    
                }label: {
                    Image(systemName: "magnifyingglass")
                }
                
                Button{
                    
                }label: {
                    Image(systemName: "cart.fill")
                }
                Button{
                    profileOpen = true
                }label: {
                    Image(systemName: "person.circle.fill")
                }.sheet(isPresented: $profileOpen) {
                    
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
            Spacer()
            
        }
    }
}

#Preview {
    DireccionView()
}
