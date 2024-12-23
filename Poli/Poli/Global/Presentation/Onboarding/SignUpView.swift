//
//  SignUpView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        ZStack {
            Color(.whiteBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 50) {
                Text("회원가입")
                    .font(.title1_semibold_32)
                    .foregroundColor(.blackText)
                    .bold()
                
                VStack(spacing: 20) {
                    PoliTextField(placeholder: "이메일", text: $viewModel.email)
                    
                    PoliTextField(placeholder: "비밀번호", text: $viewModel.password, isSecure: true)
                    
                    PoliTextField(placeholder: "비밀번호 확인", text: $viewModel.confirmPassword, isSecure: true)
                }
                
                Button(action: {
                    viewModel.signUp()
                }) {
                    Text("가입하기")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(.blackText)
                        .foregroundColor(.whiteBackground)
                        .cornerRadius(8)
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $viewModel.isSignedUp) {
            Text("Welcome! Your account has been created.")
                .font(.title)
        }
    }
}
