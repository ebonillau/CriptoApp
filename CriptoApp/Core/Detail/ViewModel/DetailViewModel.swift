//
//  c.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 22/06/22.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
        
    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }

    private func addSubscribers() {
        coinDetailDataService.$coinDetail
            .sink { [weak self] coinDetail in
                print("Recieved coinDetailDataService")
                print(coinDetail)
            }
            .store(in: &cancellables)
    }
}
