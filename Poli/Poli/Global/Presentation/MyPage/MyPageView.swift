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
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("닉네임:")
                            .font(.text5_medium_16)
                        Spacer()
                        Text(viewModel.displayName)
                            .font(.text6_medium_14)
                    }
                    
                    HStack {
                        Text("이메일:")
                            .font(.text5_medium_16)
                        Spacer()
                        Text(viewModel.email)
                            .font(.text6_medium_14)
                    }
                }
                .padding()
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
                }
                ) {
                    Text("로그아웃")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .foregroundColor(.primary)
            }
            .padding()
            .navigationTitle("마이페이지")
        }
    }

