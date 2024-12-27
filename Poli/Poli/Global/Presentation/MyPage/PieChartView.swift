//
//  PieChartView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/27/24.
//

import SwiftUI

struct PieChartView: View {
    var liberalPercentage: Int
    var conservativePercentage: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Conservative slice
                Circle()
                    .trim(from: 0, to: CGFloat(conservativePercentage) / 100)
                    .stroke(Color.blue, lineWidth: geometry.size.width / 2)
                    .rotationEffect(.degrees(-90))
                
                // Liberal slice
                Circle()
                    .trim(from: CGFloat(conservativePercentage) / 100, to: 1)
                    .stroke(Color.red, lineWidth: geometry.size.width / 2)
                    .rotationEffect(.degrees(-90))
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
