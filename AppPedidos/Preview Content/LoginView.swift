//
//  LoginView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 25/2/25.
//

import SwiftUI
import FirebaseAuth
import CryptoKit

struct LoginView: View {
    @Binding var isLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Environment(\.dismiss) var dismiss
    private let login: [String: String] = ["ex@gmail.com": "03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4"]
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .font(.custom("AppLogo", size: 80))
            Form {
                Section {
                    HStack {
                        Text("Email")
                        Spacer(minLength: 55)
                        TextField("example@gmail.com", text: $email)
                            .keyboardType(.emailAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                    }
                    HStack {
                        Text("Contraseña")
                        Spacer()
                        SecureField("********", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .listRowBackground(Color.gray)
            }
            .frame(maxHeight: 150)
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button("Login") {
                loginUser(email: email, password: password)
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .padding()
    }
    
    func loginUser(email: String, password: String) {
        let hashedPwd = hashPassword(password: password)
        if checkLoginArray(email: email, password: hashedPwd) {
            dismiss()
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                if error == nil {
                    dismiss()
                } else {
                    errorMessage = "Error: Usuario o contraseña incorrectos"
                }
            }
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
