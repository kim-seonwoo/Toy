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
            Text("My Page")
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 10) {
                HStack {
                    Text("닉네임:")
                        .bold()
                    Spacer()
                    Text(viewModel.displayName)
                }
                
                HStack {
                    Text("보수(Conservative) 카운트:")
                        .bold()
                    Spacer()
                    Text("\(viewModel.conservativeCount)")
                }
                
                HStack {
                    Text("진보(Liberal) 카운트:")
                        .bold()
                    Spacer()
                    Text("\(viewModel.liberalCount)")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .onAppear {
                viewModel.fetchUserData()
            }
        }
        .padding()
    }
}
