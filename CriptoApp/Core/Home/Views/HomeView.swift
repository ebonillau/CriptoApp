//
//  HomeView.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 1/06/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var showPortofolio: Bool = false
    @State private var showPortofolioView: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
                .sheet(isPresented: $showPortofolioView) {
                    PortofolioView(showPortofolioView: $showPortofolioView)
                        .environmentObject(viewModel)
                }
            VStack {
                HomeHeader
                HomeStatisticsView(showPortofolio: $showPortofolio)
                SearchBarView(searchText: $viewModel.searchText)
                ColumnsTitle
                if showPortofolio {
                    PortofolioCoinsList
                        .transition(.move(edge: .leading))
                } else {
                    AllCoinsList
                        .transition(.move(edge: .trailing))
                }
                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(DeveloperPreview.instance.homeVM)
        .preferredColorScheme(.dark)
    }
}

extension HomeView {
    
    private var HomeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortofolio ? "plus" : "info")
                .animation(.none, value: showPortofolio)
                .background(
                    CircleButtonAnimationView(animate: $showPortofolio)
                        .frame(width: 70, height: 70)
                )
                .onTapGesture {
                    if showPortofolio {
                        showPortofolioView.toggle()
                    }
                }
            Spacer()
            Text(showPortofolio ? "Portofolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none, value: showPortofolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(showPortofolio ? .degrees(180) : .zero)
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortofolio.toggle()
                    }
                }
        }
        .padding()
    }
    
    private var AllCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                NavigationLink(destination: NavigationLazyView(DetailView(coin: coin))) {
                    CoinRowView(coin: coin, showHoldingColumn: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.reloadData()
        }
    }
    
    private var PortofolioCoinsList: some View {
        List {
            ForEach(viewModel.portofoliosCoins) { coin in
                NavigationLink(destination: NavigationLazyView(DetailView(coin: coin))) {
                    CoinRowView(coin: coin, showHoldingColumn: true)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                }
             }
        }
        .listStyle(.plain)
        .refreshable {
            viewModel.reloadData()
        }
    }
    
    private var ColumnsTitle: some View {
        HStack {
            HStack {
                Text("Coins")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOption == .rank ||
                             viewModel.sortOption == .rankReversed
                             ? 1 : 0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation {
                    viewModel.sortOption = viewModel.sortOption
                    == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortofolio {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(viewModel.sortOption == .holdings ||
                                 viewModel.sortOption == .holdingsReversed
                                 ? 1 : 0)
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation {
                        viewModel.sortOption = viewModel.sortOption
                        == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(viewModel.sortOption == .price ||
                             viewModel.sortOption == .priceReversed
                             ? 1 : 0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
            }
            .onTapGesture {
                withAnimation {
                    viewModel.sortOption = viewModel.sortOption
                    == .price ? .priceReversed : .price
                }
            }
            .frame(width: getRect().width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .padding(.horizontal, 10)
    }
}
