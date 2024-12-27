//
//  MyPageView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI

struct MyPageView: View {
    @StateObject private var viewModel = MyPageViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text("\(viewModel.displayName)님의 성향은?")
                .font(.title2)
                .padding()

            Text(" \(viewModel.politicalOrientation.rawValue)")
                .font(.title)
                .bold()

            VStack(spacing: 50) {
                VStack(spacing: 10) {
                    Text("보수 성향 \(viewModel.conservativePercentage)%")
                        .font(.headline)
                    Text("진보 성향 \(viewModel.liberalPercentage)%")
                        .font(.headline)
                }
                
                PieChartView(
                    liberalPercentage: viewModel.liberalPercentage,
                    conservativePercentage: viewModel.conservativePercentage
                )
                .frame(width: 100, height: 100)
            }

            // 에러 메시지
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.logout()
            }) {
                Text("로그아웃")
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(.blackText)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .onAppear {
            viewModel.fetchUserData()
        }
        .padding()
    }
}

