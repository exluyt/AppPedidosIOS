//
//  ContentView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 6/2/25.
//

import SwiftUI

struct ContentView: View {
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
                    
                }label: {
                    Image(systemName: "person.circle.fill")
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
        }
        .padding(0)
    }

}

#Preview {
    ContentView()
}
