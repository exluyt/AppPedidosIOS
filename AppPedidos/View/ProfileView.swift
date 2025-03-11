//
//  ProfileView.swift
//  AppPedidos
//
//  @author: Arpad Kiss, Henry Illescas
//

import SwiftUI

struct ProfileView: View{
    @Binding var isPresented: Bool
    @Binding var mail: String
    @State private var is_on_notifications = false
    @State private var username = "Hiromy"
    @State private var direccion = "Add Direction"
    @State private var is_presented = false;
    @Binding var isLoggedIn: Bool
    @State var toDirection = false
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
                        toDirection = true
                    }label: {
                        Text(direccion)
                        Image(systemName: "arrow.right")
                    }
                    NavigationLink(destination: DireccionView()) {
                        EmptyView()
                    }
                    .hidden()
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
                isLoggedIn = false;
                mail = ""
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
