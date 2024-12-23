//
//  LoginView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

//
//  LoginView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showSignUpView = false // 회원가입 화면 표시 플래그
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.whiteBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 50) {
                    Image(.logo)
                        .frame(width: 326, height: 114)
                    
                    VStack(spacing: 20) {
                        PoliTextField(placeholder: "이메일", text: $viewModel.email)
                        
                        PoliTextField(placeholder: "비밀번호", text: $viewModel.password, isSecure: true)
                        
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.conservative)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            viewModel.login()
                        }) {
                            Text("로그인")
                                .bold()
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(.blackText)
                                .foregroundColor(.whiteBackground)
                                .cornerRadius(8)
                        }
                        
                        NavigationLink(destination: SignUpView(), isActive: $showSignUpView) {
                            Button(action: {
                                showSignUpView = true
                            }) {
                                Text("회원가입")
                                    .foregroundColor(.blackText)
                                    .padding(.top, 10)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
                Text("Welcome! You are logged in.")
                    .font(.title)
            }
        }
    }
}

#Preview {
    LoginView()
}
