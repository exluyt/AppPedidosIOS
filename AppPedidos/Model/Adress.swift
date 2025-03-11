//
//  Adress.swift
//  AppPedidos
//
//  Created by Usuario invitado on 11/3/25.
//
import Foundation

struct Adress: Identifiable, Codable, Equatable {
    let id = UUID()
    let email: String
    var name: String
    var phone: String
    var street: String
    var streetNumber: String
    var portal: String
    var postalCode: String
    var cityProvince: String
}
