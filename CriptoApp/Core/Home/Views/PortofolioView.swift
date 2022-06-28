//
//  zx.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 14/06/22.
//

import SwiftUI

struct PortofolioView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    
    @Binding var showPortofolioView: Bool
    @State var selectedCoin: Coin? = nil
    @State var quantityText: String = ""
    @State var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $viewModel.searchText)
                    PortofolioCoinsList
                    if selectedCoin != nil {
                        PortofolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portofolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(showView: _showPortofolioView)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationBarTrailing
                }
            }
            .onChange(of: viewModel.searchText) { newValue in
                if newValue == "" {
                    removeSelectionCoin()
                }
            }
        }
    }
}

struct PortofolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortofolioView(showPortofolioView: .constant(true))
            .environmentObject(dev.homeVM)
    }
}

extension PortofolioView {
    
    private var PortofolioCoinsList: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.searchText.isEmpty ? viewModel.portofoliosCoins : viewModel.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(8)
                        .onTapGesture {
                            withAnimation {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.gray, lineWidth: selectedCoin?.id == coin.id ? 2 : 1)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 2)
        })
        .padding(.vertical, 10)
    }
    
    private func updateSelectedCoin(coin: Coin) {
        selectedCoin = coin
        if let portofolioCoin = viewModel.portofoliosCoins.first(where: { $0.id == coin.id }) {
            if let amount = portofolioCoin.currentHoldings {
                quantityText = "\(amount)"
            }
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        guard let quantity = Double(quantityText) else {
            return 0
        }
        return quantity * (selectedCoin?.currentPrice ?? 0)
    }
    
    private var PortofolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(nil, value: selectedCoin?.id)
        .padding()
    }
    
    private var NavigationBarTrailing: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1 : 0)
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1 : 0
            )

        }
        .font(.headline)
        .foregroundColor(.theme.accent)
    }
    
    private func saveButtonPressed() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else { return }
        
         viewModel.updatePortofolio(coin: coin, amount: amount)
        
        withAnimation {
            showCheckMark = true
            removeSelectionCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCheckMark = false
            }
        }
    }
    
    private func removeSelectionCoin() {
        selectedCoin = nil
        viewModel.searchText = ""
        quantityText = ""
    }
    
}
