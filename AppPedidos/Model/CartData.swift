//
//  CartData.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//


struct CartData: Codable {
    let userEmail: String
    var cartGames: [Game]
}