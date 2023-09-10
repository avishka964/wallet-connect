//
//  MetamaskModel.swift
//  WalletConnect
//
//  Created by Avishka Kapuruge on 2023-09-10.
//

import SwiftUI
import Combine
import metamask_ios_sdk

extension Notification.Name {
    static let Connection = Notification.Name("connection")
}

class MetamaskModel: ObservableObject {
    
    @Published var connectionStatus = "Offline" {
        didSet {
            NotificationCenter.default.post(name: .Connection, object: nil, userInfo: ["value": connectionStatus])
        }
    }
    
    @Published var chainID = ""
    @Published var ethAddress = ""
    
    @ObservedObject private var ethereum = MetaMaskSDK.shared.ethereum
    
    let dappName = "Dub Dapp"
    let dappUrl = "https://dubdapp.com"
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        observeConnectionStatus()
    }
    
    private func observeConnectionStatus() {
        ethereum.$connected
            .sink { [weak self] isConnected in
                self?.connectionStatus = isConnected ? "Connected" : "Disconnected"
            }
            .store(in: &cancellables)
    }
    
    func connectWallet() {
        let dapp = Dapp(name: dappName, url: dappUrl)
        ethereum.connect(dapp)?
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Connection error \(error.localizedDescription)")
                default: break
                }
            }, receiveValue: { result in
                print("Connection result: \(result)")
                DispatchQueue.main.async {
                    self.chainID = self.ethereum.chainId
                    self.ethAddress = self.ethereum.selectedAddress
                }
            })
            .store(in: &cancellables)
    }

}
