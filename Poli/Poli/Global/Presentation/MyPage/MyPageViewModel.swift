//
//  MyPageViewModel.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import FirebaseFirestore
import FirebaseAuth

class MyPageViewModel: ObservableObject {
    @Published var displayName: String = "Anonymous"
    @Published var liberalCount: Int = 0
    @Published var conservativeCount: Int = 0
    @Published var errorMessage: String = ""

    private let db = Firestore.firestore()

    func fetchUserData() {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = "You must be logged in."
            return
        }

        let userRef = db.collection("users").document(user.uid)
        userRef.getDocument { snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch user data: \(error.localizedDescription)"
                }
            } else if let data = snapshot?.data() {
                DispatchQueue.main.async {
                    self.displayName = data["displayName"] as? String ?? "Anonymous"
                    self.liberalCount = data["liberal"] as? Int ?? 0
                    self.conservativeCount = data["conservative"] as? Int ?? 0
                }
            }
        }
    }
}
