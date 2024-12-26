//
//  ForumViewModel.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import FirebaseFirestore
import SwiftUI

class ForumViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var errorMessage: String = ""
    
    private let db = Firestore.firestore()

    func fetchPosts() {
        db.collection("posts")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to fetch posts: \(error.localizedDescription)"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.posts = snapshot?.documents.compactMap { doc -> Post? in
                            let data = doc.data()
                            return Post(
                                id: doc.documentID,
                                title: data["title"] as? String ?? "",
                                content: data["content"] as? String ?? "",
                                author: data["author"] as? [String: String] ?? [:],
                                createdAt: data["createdAt"] as? String ?? "Unknown date"
                            )
                        } ?? []
                    }
                }
            }
    }
}
