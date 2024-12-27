//
//  AppStateManager.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/27/24.
//

import FirebaseAuth
import Combine

class AppStateManager: ObservableObject {
    @Published var isLoggedIn: Bool = false

    static let shared = AppStateManager()

    init() {
        checkAuthState()
    }

    func checkAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = (user != nil)
            }
        }
    }

    func logOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        } catch {
            print("Failed to log out: \(error.localizedDescription)")
        }
    }
}
