//
//  ContentView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 6/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isProfilePresented = false

    var body: some View {
        VStack {
            HeaderBar()
            
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
