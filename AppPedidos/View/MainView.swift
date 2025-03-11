//
//  MainView.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//


import SwiftUI

struct MainView: View {
    @State private var isProfilePresented = false
    @StateObject var viewModel = GameViewModel()
    @State var isLoggedIn = false
    @State var email = ""
    @StateObject var cartManager: CartManager
    
    init() {
        _cartManager = StateObject(wrappedValue: CartManager(userEmail: ""))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HeaderBar(cartManager: cartManager, email: $email, isLoggedIn: $isLoggedIn, title: "LootBox Store", search: true, cart: true, profile: true)
                    TitleLine(title: "Top Games")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.topGames) { game in
                                GameView(game: game, cartManager: cartManager)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    
                    TitleLine(title: "Suggestions for you")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.suggestedGames) { game in
                                GameRow(game: game, cartManager: cartManager)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9)
                    
                 TitleLine(title: "Strategy")
                  ScrollView(.horizontal, showsIndicators: false) {
                      HStack {
                          ForEach(viewModel.strategyGames) { game in
                               GameRow(game: game, cartManager: cartManager)
                           }
                       }
                    }.frame(width: UIScreen.main.bounds.width * 0.9)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .onAppear {
                    if !email.isEmpty {
                        cartManager.updateEmail(email)
                    }
                    viewModel.loadGames()
                    viewModel.loadTopGames()
                    viewModel.loadStrategyGames()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
