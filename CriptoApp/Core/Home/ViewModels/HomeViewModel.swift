//
//  ds.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 3/06/22.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var statistics: [Statistic] = []
    @Published var allCoins: [Coin] = []
    @Published var portofoliosCoins: [Coin] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .holdings

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portofolioDataService = PortofolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
        
        $allCoins
            .combineLatest(portofolioDataService.$savedEntities)
            .map(mapPortofoliosCoins)
            .sink { [weak self] coins in
                guard let self = self else { return }
                self.portofoliosCoins = self.sortPortofolioCoinsIfNeeded(coins: coins)
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portofoliosCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.statistics = stats
            }
            .store(in: &cancellables)
    }
    
    func reloadData() {
        coinDataService.getCoins()
        marketDataService.getMarketData()
    }
    
    func updatePortofolio(coin: Coin, amount: Double) {
        portofolioDataService.updatePortofolio(coin: coin, amount: amount)
        
    }
    
    private func filterAndSortCoins(text: String, coins: [Coin], sortOption: SortOption) -> [Coin] {
        var filteredCoins = filterCoins(text: text, coins: coins)
        sortCoins(sortOption: sortOption, coins: &filteredCoins)
        return filteredCoins
    }
    
    private func filterCoins(text: String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        let lowercaseText = text.lowercased()
        return coins.filter { coin in
            return coin.name.lowercased().contains(lowercaseText) ||
                   coin.symbol.lowercased().contains(lowercaseText) ||
                   coin.id.lowercased().contains(lowercaseText)
        }
    }
    
    private func sortCoins(sortOption: SortOption, coins: inout [Coin]) {
        switch sortOption {
        case .rank, .holdings:
            coins.sort { $0.rank < $1.rank }
        case .rankReversed, .holdingsReversed:
            coins.sort { $0.rank > $1.rank }
        case .price:
            coins.sort { $0.currentPrice < $1.currentPrice }
        case .priceReversed:
            coins.sort { $0.currentPrice > $1.currentPrice }
        }
    }
    
    private func sortPortofolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOption {
        case .holdings:
            return coins.sorted { $0.currentHoldingsValue < $1.currentHoldingsValue }
        case .holdingsReversed:
            return coins.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }
        default:
            return coins
        }
    }

    

    private func mapPortofoliosCoins(coinModels: [Coin], portofolioEntities: [Portofolio]) -> [Coin] {
        coinModels.compactMap { coin -> Coin? in
            guard let entity = portofolioEntities.first(where: { $0.coinID == coin.id }) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func mapGlobalMarketData(marketData: MarketData?, portofolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        guard let data = marketData else {
            return stats
        }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        let portofolioValue = portofolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0, +)
        
        let previousValue = portofolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
            let previousValue = currentValue / (percentChange+1)
            return previousValue
        }.reduce(0, +)
            
        var percentageChange = ((portofolioValue - previousValue) / previousValue) * 100
        if percentageChange.isNaN { percentageChange = 0 }
        
        let portofolio = Statistic(title: "Portofolio Value", value: portofolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portofolio
        ])
        return stats
    }
}
