//
//  TitleLine.swift
//  AppPedidos
//
//  Created by Usuario invitado on 27/2/25.
//

import SwiftUI

struct TitleLine: View {
    
    let title:String
    
    var body: some View {
        Section{
            Text(title)
                .frame(width: UIScreen.main.bounds.width * 0.9,
                       alignment: .leading )
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.black),
                    alignment: .bottom
                )
                .font(.custom("Geist-Medium", size: 20))
        }
    }
}
