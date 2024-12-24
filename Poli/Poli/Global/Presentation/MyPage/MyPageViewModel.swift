//
//  MyPageViewModel.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI
import FirebaseAuth

class MyPageViewModel: ObservableObject {
    @Published var displayName: String = ""
    @Published var email: String = ""
    @Published var errorMessage: String = ""
    
    init() {
        fetchUserInfo()
    }

    /// 현재 로그인된 사용자 정보 조회
    func fetchUserInfo() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "사용자 정보가 없습니다. 다시 로그인하세요."
            return
        }
        
        // 유저 정보 업데이트
        self.displayName = user.displayName ?? "닉네임 없음"
        self.email = user.email ?? "이메일 없음"
    }
    
    /// 로그아웃 기능
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = "로그아웃 중 오류 발생: \(error.localizedDescription)"
        }
    }
}
