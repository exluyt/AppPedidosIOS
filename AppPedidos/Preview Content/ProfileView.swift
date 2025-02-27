//
//  ProfileView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 20/2/25.
//

import SwiftUI

struct ProfileView: View{
    @Binding var isPresented: Bool
    
    @State private var is_on_notifications = false
    @State private var username = "Hiromy"
    @State private var mail = "comotutellamas@gmail.com"
    @State private var direccion = "Add Direction"
    @State private var is_presented = false;
    var body: some View {
        VStack{
            Text("Profile")
                .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                .font(.custom("Geist-Medium", size: 26))
                .padding(20)
            HStack{
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                VStack(alignment: .leading){
                    Text(username)
                    Text(mail)
                        Button {
                            
                        }label: {
                            Text(direccion)
                            Image(systemName: "arrow.right")
                        }
                    
                }
                .font(.custom("Geist-Medium", size: 18))
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.9 , alignment: .leading)
            
            Toggle(isOn: $is_on_notifications) {
                    Text("Subscribe to notifications")
                    .font(.custom("Geist-Medium", size: 18))
            }.frame(width: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                

            Spacer()
            
            Button("Log out", role: .destructive) {
                is_presented = true
            }
            .alert("Are you sure?", isPresented: $is_presented) {
                Button("Log Out", role: .destructive) {
                    isPresented = false;
                }
                Button("Cancel", role: .cancel) { }
                }
        }
    }
}
