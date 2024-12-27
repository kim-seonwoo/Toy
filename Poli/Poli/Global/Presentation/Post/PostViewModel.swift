//
//  PostViewModel.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/26/24.
//

import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class PostViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var errorMessage: String = ""
    @Published var isPostCreated: Bool = false
    
    private let db = Firestore.firestore()

    func createPost() {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "You must be logged in to create a post."
            AppStateManager.shared.logOut()
            return
        }
        
        let postId = UUID().uuidString
        let postRef = db.collection("posts").document(postId)
        let createdAt = Date().formattedString()
        
        let postData: [String: Any] = [
            "title": title,
            "content": content,
            "author": [
                "uid": user.uid,
                "displayName": user.displayName ?? "Anonymous"
            ],
            "conservative": 0,
            "liberal": 0,
            "likedBy": [],
            "createdAt": createdAt
        ]
        
        postRef.setData(postData) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to create post: \(error.localizedDescription)"
                }
            } else {
                DispatchQueue.main.async {
                    self.isPostCreated = true
                }
            }
        }
    }
}

extension Date {
    func formattedString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
}
