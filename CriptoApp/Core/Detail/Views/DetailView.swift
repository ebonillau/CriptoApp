//
//  fd.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 22/06/22.
//

import SwiftUI

struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}

struct DetailView: View {
    
    @StateObject private var viewModel: DetailViewModel
    @State private var showFullDescription: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(coin: Coin) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }

    var body: some View {
        ScrollView {
            VStack {
                ChartView(coin: viewModel.coin)
                    .padding(.vertical)
                    .padding(.horizontal, 5)
                VStack(spacing: 20) {
                    OverviewTitle
                    Divider()
                    Description
                    OverviewGrid
                    AditionalTitle
                    Divider()
                    AditionalGrid
                    Website
                }
                .padding()
            }
        }
        .navigationTitle(viewModel.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationBarTrailingItem
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}

extension DetailView {
    
    private var OverviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var OverviewGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: General.standarSpacing,
                  pinnedViews: []) {
            ForEach(viewModel.overviewStatistics) { statistic in
                StatisticView(statistic: statistic)
            }
        }
    }
    
    private var AditionalTitle: some View {
        Text("Aditional Details")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var AditionalGrid: some View {
        LazyVGrid(columns: columns,
                  alignment: .leading,
                  spacing: General.standarSpacing,
                  pinnedViews: []) {
            ForEach(viewModel.adicionalStatistics) { statistic in
                StatisticView(statistic: statistic)
            }
        }
    }
    
    private var NavigationBarTrailingItem: some View {
        HStack {
            Text(viewModel.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.secondaryText)
            CoinImageView(coin: viewModel.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var Description: some View {
        ZStack {
            if let description = viewModel.coinDescription, !description.isEmpty {
                VStack(alignment: .leading) {
                    Text(description)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(.theme.secondaryText)
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Read Less..." : "Read More...")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    private var Website: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let websiteURL = viewModel.websiteURL, let url = URL(string: websiteURL) {
                Link("Website", destination: url)
            }
            if let redditURL = viewModel.redditURL, let url = URL(string: redditURL) {
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}
