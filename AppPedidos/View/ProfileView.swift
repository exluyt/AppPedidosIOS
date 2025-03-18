//
//  ProfileView.swift
//  AppPedidos
//
//  @author: Arpad Kiss, Henry Illescas
//

import SwiftUI

struct ProfileView: View {
    @Binding var isPresented: Bool
    @Binding var mail: String
    @State private var is_on_notifications = false
    @State private var username = ""
    @State private var direccion = "Add Direction"
    @State private var is_presented = false
    @Binding var isLoggedIn: Bool
    
    @ObservedObject private var userManager = UserManager()
    
    // Estado para manejar el cambio en el texto
    @State private var newUsername = ""
    @State private var isEditing = false
    @State private var usernameChanged = false

    var body: some View {
        VStack () {
            Text("Profile")
                .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                .font(.custom("Geist-Medium", size: 26))
                .padding(20)
            
            HStack {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                
                VStack(alignment: .leading) {
                    // Editable username field
                    TextField("Username", text: $newUsername, onEditingChanged: { editing in
                        isEditing = editing
                        if !editing {
                            // Solo guardar cuando el usuario termina de escribir
                            saveUsername()
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 5)
                    .font(.custom("Geist-Medium", size: 18))
                    .onAppear {
                        newUsername = username // Iniciar con el valor actual
                    }
                    
                    Text(mail)
                    
                    // NavigationLink a DireccionView
                    NavigationLink(destination: DireccionView(userEmail: mail)) {
                        HStack {
                            Text(direccion)
                            Image(systemName: "arrow.right")
                        }
                        .font(.custom("Geist-Medium", size: 18))
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .font(.custom("Geist-Medium", size: 18))
            }
            .frame(width: UIScreen.main.bounds.width * 0.9 , alignment: .leading)
            
            Toggle(isOn: $is_on_notifications) {
                Text("Subscribe to notifications")
                    .font(.custom("Geist-Medium", size: 18))
            }
            .frame(width: UIScreen.main.bounds.width * 0.7, alignment: .leading)
            
            Spacer()
            
            Button("Log out", role: .destructive) {
                is_presented = true
            }
            .alert("Are you sure?", isPresented: $is_presented) {
                Button("Log Out", role: .destructive) {
                    isPresented = false
                    isLoggedIn = false
                    mail = ""
                }
                Button("Cancel", role: .cancel) { }
            }
        }
        .onAppear {
            if let user = userManager.loadUser(email: mail) {
                username = user.username
                newUsername = username // Asignar valor inicial al campo de texto
            }
        }
    }
    
    // Función para guardar el username cuando se termina de editar
    private func saveUsername() {
        if newUsername != username {
            username = newUsername
            userManager.saveUser(email: mail, username: username)
            print("Username actualizado: \(username)")
        }
    }
}

