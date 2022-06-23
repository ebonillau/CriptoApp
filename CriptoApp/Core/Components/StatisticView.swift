//
//  sd.swift
//  CriptoApp (iOS)
//
//  Created by Enrique Miguel Bonilla Untiveros on 9/06/22.
//

import SwiftUI

struct StatisticView: View {
    
    let statistic: Statistic

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statistic.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            Text(statistic.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (statistic.percentageChange ?? 0) >= 0 ? 0 : 180))
                Text(statistic.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                .bold()
            }
            .foregroundColor((statistic.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(statistic.percentageChange == nil ? 0 : 1)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(statistic: dev.stat1)
            StatisticView(statistic: dev.stat2)
            StatisticView(statistic: dev.stat3)
        }
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
