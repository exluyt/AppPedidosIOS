//
//  ProfileView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 20/2/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack{
            Text("Profile")
                .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                .font(.custom("Geist-Medium", size: 26))
                .padding(20)
            HStack{
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                VStack{
                    Text("User")
                        .frame(width:UIScreen.main.bounds.width, alignment: .leading)
                    Text("Mail")
                        .frame(width:UIScreen.main.bounds.width, alignment: .leading)
                    Text("Direccion")
                        .frame(width:UIScreen.main.bounds.width, alignment: .leading)
                        
                }
                
                
                .font(.custom("Geist-Medium", size: 18))
                .background(.red)
            }
            .frame(width: UIScreen.main.bounds.width * 0.9 , alignment: .leading)
            
            Spacer()
            
            Button("Cerrar sesión", role: .destructive) {
                print("Cerrando sesión")
            }
        }
    }
}

#Preview {
    ProfileView()
}
