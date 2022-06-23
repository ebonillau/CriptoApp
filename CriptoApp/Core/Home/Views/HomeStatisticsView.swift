//
//  sd.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 10/06/22.
//

import SwiftUI

struct HomeStatisticsView: View {
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @Binding var showPortofolio: Bool

    var body: some View {
        HStack(spacing: 0) {
            ForEach(viewModel.statistics) { statistic in
                StatisticView(statistic: statistic)
                    .frame(width: getRect().width/3)
            }
        }
        .padding(.horizontal, 0)
        .frame(width: getRect().width,
               alignment: showPortofolio ? .trailing : .leading)
    }
}

struct HomeStatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatisticsView(showPortofolio: .constant(true))
            .environmentObject(dev.homeVM)
    }
}
