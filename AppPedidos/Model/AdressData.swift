//
//  AdressData.swift
//  AppPedidos
//
//  @author: Arpad Kiss, Henry Illescas
//

import Foundation

struct AdressData: Codable {
    let userEmail: String
    var adresses: [Adress]
}
