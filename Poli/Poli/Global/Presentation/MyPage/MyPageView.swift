//
//  MyPageView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI

struct MyPageView: View {
    @StateObject private var viewModel = MyPageViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color(.whiteBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("My Page")
                    .font(.title1_semibold_32)
                    .foregroundColor(.blackText)
                    .bold()
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("닉네임:")
                            .font(.text5_medium_16)
                            .foregroundColor(.blackText)
                        Spacer()
                        Text(viewModel.displayName)
                            .font(.text6_medium_14)
                            .foregroundColor(.blackText)
                    }
                    
                    HStack {
                        Text("이메일:")
                            .font(.text5_medium_16)
                            .foregroundColor(.blackText)
                        Spacer()
                        Text(viewModel.email)
                            .font(.text6_medium_14)
                            .foregroundColor(.blackText)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.logout()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("로그아웃")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.blackText)
                        .foregroundColor(.whiteBackground)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}
