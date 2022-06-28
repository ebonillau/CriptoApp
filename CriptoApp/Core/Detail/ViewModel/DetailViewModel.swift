//
//  c.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 22/06/22.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
        
    @Published var overviewStatistics: [Statistic] = []
    @Published var adicionalStatistics: [Statistic] = []
    @Published var coin: Coin
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private let coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }

    private func addSubscribers() {
        coinDetailDataService.$coinDetail
            .combineLatest($coin)
            .map(mapDataToStatistic)
            .sink { [weak self] returnStatistics in
                self?.overviewStatistics = returnStatistics.overview
                self?.adicionalStatistics = returnStatistics.adicional
            }
            .store(in: &cancellables)
        
        coinDetailDataService.$coinDetail
            .sink { [weak self] coinDetail in
                guard let self = self else { return }
                self.coinDescription = coinDetail?.readableDescription
                self.websiteURL = coinDetail?.links?.homepage?.first
                self.redditURL = coinDetail?.links?.subredditURL
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistic(coinDetail: CoinDetail?, coin: Coin) -> (overview: [Statistic], adicional: [Statistic]) {
        let overviewArray = createOverviewArray(coin: coin)
        let adicionalArray = createAditionalArray(coinDetail: coinDetail)
        return (overviewArray, adicionalArray)
    }
    
    private func createOverviewArray(coin: Coin) -> [Statistic] {
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let priceStat = Statistic(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volume", value: volume)
        
        let overviewArray: [Statistic] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        
        return overviewArray
    }
    
    private func createAditionalArray(coinDetail: CoinDetail?) -> [Statistic] {
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = Statistic(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = Statistic(title: "24h Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "0" : "\(blockTime)"
        let blockStat = Statistic(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
        
        let adicionalArray: [Statistic] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        
        return adicionalArray
    }
}
