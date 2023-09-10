//
//  ContentView.swift
//  WalletConnect
//
//  Created by Avishka Kapuruge on 2023-09-10.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var metamaskModel = MetamaskModel()
    @State private var status = "Offline"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            Text("Metamask").font(.title)
            
            Text("Status:  \(metamaskModel.connectionStatus)").font(.footnote)
            
            Text("Chain ID:  \(metamaskModel.chainID)").font(.footnote)
            
            Text("Account:  \(metamaskModel.ethAddress)").font(.footnote)
           
            
            Button {
                metamaskModel.connectWallet()
            } label: {
                Text("Connect")
                    .frame(width: 300, height: 50)
                    .background(Color.blue).foregroundColor(Color.white).cornerRadius(10)
            }
            
        }
        .onReceive(NotificationCenter.default.publisher(for: .Connection)) { notification in
            status = notification.userInfo?["value"] as? String ?? "Offline"
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
