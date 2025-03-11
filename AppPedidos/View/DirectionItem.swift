//
//  DirectionItem.swift
//  AppPedidos
//
//  @author: Arpad Kiss, Henry Illescas
//

import SwiftUI

struct DirectionItem: View {
    @State public var address:Address
    var body: some View {
        VStack{
            HStack {
                
                VStack(alignment: .leading) {
                    Text("\(address.name)  \(address.phone)")
                    Text("\(address.street) \(address.streetNumber)  Portal \(address.portal)")
                    Text("\(address.postalCode)  \(address.cityProvince)")
                    
                }
                .font(.custom("Geist-Regular", size: 14))
                Spacer()
                Rectangle()
                    .frame(width: 40, height: 40, alignment: .top)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
            Button{
                
            }label: {
                Text("Edit")
            }
            .buttonStyle(.borderedProminent)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray))
    }
}
