//
//  CoinRowView.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 2/06/22.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    let showHoldingColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            LeftColumn
            Spacer()
            if showHoldingColumn {
                CenterColumn
            }
            RightColumn
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingColumn: true)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin, showHoldingColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension CoinRowView {
    
    private var LeftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text("\(coin.symbol.uppercased())")
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(.theme.accent)
        }
    }
    
    private var CenterColumn: some View {
        HStack(spacing: 0) {
            VStack(alignment: .trailing) {
                Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                    .bold()
                Text((coin.currentHoldings ?? 0).asNumberString())
            }
            .foregroundColor(.theme.accent)
        }
    }
    
    private var RightColumn: some View {
        HStack(spacing: 0) {
            VStack(alignment: .trailing) {
                Text(coin.currentPrice.asCurrencyWith6Decimals())
                    .bold()
                    .foregroundColor(.theme.accent)
                Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                    .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? .theme.green : .theme.red)
            }
        }
        .frame(width: getRect().width / 3.5, alignment: .trailing)
    }
}
