//
//  LoginView.swift
//  AppPedidos
//
//  @author: Arpad Kiss, Henry Illescas
//

import SwiftUI
//import FirebaseAuth
import CryptoKit

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @Binding var email: String
    @State private var password = ""
    @State private var errorMessage = ""
    @Environment(\.dismiss) var dismiss
    private let login: [String: String] = ["dragonquest@gmail.com": "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "triggersniper@gmail.com" : "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "casualmente88@gmail.com" : "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4", "speedracerpro@gmail.com" : "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4" ]
    
    var body: some View {
        VStack {
            Text("Login")
                .frame(width: UIScreen.main.bounds.width * 0.9,
                       alignment: .leading )
                .font(.custom("geist-semi-bold", size: 24))
            
            Image(.el)
                .imageScale(.large)
                .font(.custom("AppLogo", size: 80))
            
            Text("LootBox Store")
                .frame(width: UIScreen.main.bounds.width * 0.9,
                       alignment: .center )
                .font(.custom("geist-semi-bold", size: 24))
            
            Form {
                Section {
                    VStack {
                        Text("Email")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(0)
                        TextField("", text: $email)
                            .frame(height: 50)
                            .keyboardType(.emailAddress)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("Gray")))
                            .foregroundColor(Color.white)
                            .autocapitalization(.none)
                        
                        Text("Contraseña")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(0)
                        SecureField("", text: $password)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color("Gray")))
                            .foregroundColor(Color.white)
                    }
                    
                }
                .listRowBackground(Color("White_90"))
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            
            Button("Login") {
                loginUser(email: email, password: password)
            }
            .buttonStyle(.borderedProminent)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
    }
    
    func loginUser(email: String, password: String) {
        let hashedPwd = hashPassword(password: password)
        if checkLoginArray(email: email, password: hashedPwd) {
            self.email = email
            isLoggedIn = true
            dismiss()
        } else {
            // Esto es cuando no está conectado con Firebase. Si fuera necesario, podemos agregar autenticación aquí.
            errorMessage = "Error: Usuario o contraseña incorrectos"
        }
    }
    
    func checkLoginArray(email: String, password: String) -> Bool {
        return login[email] == password
    }
    
    func hashPassword(password: String) -> String {
        let passwordData = Data(password.utf8)
        let hashed = SHA256.hash(data: passwordData)
        return hashed.map { String(format: "%02hhx", $0) }.joined()
    }
}
