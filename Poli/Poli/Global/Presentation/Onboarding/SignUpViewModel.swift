//
//  SignUpViewModel.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI
import FirebaseAuth

class SignUpViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String = ""
    @Published var isSignedUp: Bool = false

    func signUp() {
        guard password == confirmPassword else {
            errorMessage = "비밀번호가 일치하지 않습니다."
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    if let errorCode = AuthErrorCode(rawValue: error.code) {
                        switch errorCode {
                        case .emailAlreadyInUse:
                            self?.errorMessage = "이미 사용 중인 이메일입니다."
                        case .invalidEmail:
                            self?.errorMessage = "유효하지 않은 이메일 형식입니다."
                        case .weakPassword:
                            self?.errorMessage = "비밀번호는 최소 6자 이상이어야 합니다."
                        default:
                            self?.errorMessage = error.localizedDescription
                        }
                    }
                    self?.isSignedUp = false
                } else {
                    if let user = Auth.auth().currentUser {
                        let changeRequest = user.createProfileChangeRequest()
                        changeRequest.displayName = self?.displayName
                        changeRequest.commitChanges { error in
                            if let error = error {
                                self?.errorMessage = "프로필 업데이트 중 오류 발생: \(error.localizedDescription)"
                            } else {
                                self?.isSignedUp = true
                            }
                        }
                    }
                }
            }
        }
    }
}
