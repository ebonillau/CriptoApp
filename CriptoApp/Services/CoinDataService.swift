//
//  ads.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 3/06/22.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [Coin] = []
    var subscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=USD&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        subscription = NetworkManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] coins in
                self?.allCoins = coins
                self?.subscription?.cancel()
            })
    }
}
