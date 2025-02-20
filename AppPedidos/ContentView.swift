//
//  ContentView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 6/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var profileOpen = false
    var body: some View {
        VStack {
            HStack{
                Text("PlaceHolder")
                    
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
                    ProfileView()
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
            Rectangle()
                .frame(width:UIScreen.main.bounds.width)
                .aspectRatio(16/9, contentMode: .fit)
            
            Section{
                Text("Waos")
                    .frame(width: UIScreen.main.bounds.width * 0.9,
                           alignment: .leading )
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.black),
                            alignment: .bottom
                    )
                    .font(.custom("Geist-Medium", size: 20))
                    
                Spacer()
                    .frame(height: 100)
                
            }
            
            Text("Waos 2")
                .frame(width: UIScreen.main.bounds.width * 0.9,
                       alignment: .leading )
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.black),
                        alignment: .bottom
                )
                .font(.custom("Geist-Medium", size: 20))

        }
        .padding(0)
        Spacer()
    }

}

#Preview {
    ContentView()
}
