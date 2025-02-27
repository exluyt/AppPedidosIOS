//
//  ContentView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 6/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isProfilePresented = false
    @State private var title = "LootBox Store"
    var body: some View {
        VStack {
            HeaderBar(title: title, search: true, cart: true, profile: true)
            
            TitleLine(title:"Suggestions for you")
            
                Spacer()
                    .frame(height: 100)
                
            
            TitleLine(title:"Strategy")

        }
        .padding(0)
        Spacer()
    }

}

#Preview {
    ContentView()
}
