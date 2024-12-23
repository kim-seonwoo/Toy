//
//  LoginViewModel.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false

    func login() {
        // 이메일과 패스워드로 Firebase 로그인
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isLoggedIn = false
                } else {
                    self?.errorMessage = ""
                    self?.isLoggedIn = true
                }
            }
        }
    }
}

