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
    @Published var isLoadingNextPage = false
    @Published var errorMessage: String = ""

    private let db = Firestore.firestore()
    private var lastDocument: DocumentSnapshot?
    private var isFetching = false
    private let pageSize = 20

    func fetchPosts() {
        guard !isFetching else { return }
        isFetching = true
        
        let query = db.collection("posts")
            .order(by: "createdAt", descending: true)
            .limit(to: pageSize)
        
        query.getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isFetching = false
                
                if let error = error {
                    self?.errorMessage = "Failed to fetch posts: \(error.localizedDescription)"
                } else if let snapshot = snapshot {
                    self?.posts = snapshot.documents.compactMap { doc -> Post? in
                        let data = doc.data()
                        return Post(
                            id: doc.documentID,
                            title: data["title"] as? String ?? "",
                            content: data["content"] as? String ?? "",
                            author: data["author"] as? [String: String] ?? [:],
                            conservative: data["conservative"] as? Int ?? 0,
                            liberal: data["liberal"] as? Int ?? 0,
                            likedBy: data["likedBy"] as? [String] ?? [],
                            createdAt: data["createdAt"] as? String ?? "Unknown date"
                        )
                    }
                    self?.lastDocument = snapshot.documents.last
                }
            }
        }
    }
    
    func fetchNextPage() {
        guard !isLoadingNextPage, let lastDocument = lastDocument else { return }
        isLoadingNextPage = true
        
        let query = db.collection("posts")
            .order(by: "createdAt", descending: true)
            .start(afterDocument: lastDocument)
            .limit(to: pageSize)
        
        query.getDocuments { [weak self] snapshot, error in
            DispatchQueue.main.async {
                self?.isLoadingNextPage = false
                
                if let error = error {
                    self?.errorMessage = "Failed to fetch next page: \(error.localizedDescription)"
                } else if let snapshot = snapshot {
                    let newPosts = snapshot.documents.compactMap { doc -> Post? in
                        let data = doc.data()
                        return Post(
                            id: doc.documentID,
                            title: data["title"] as? String ?? "",
                            content: data["content"] as? String ?? "",
                            author: data["author"] as? [String: String] ?? [:],
                            conservative: data["conservative"] as? Int ?? 0,
                            liberal: data["liberal"] as? Int ?? 0,
                            likedBy: data["likedBy"] as? [String] ?? [],
                            createdAt: data["createdAt"] as? String ?? "Unknown date"
                        )
                    }
                    
                    self?.posts.append(contentsOf: newPosts)
                    self?.lastDocument = snapshot.documents.last
                }
            }
        }
    }
    
    func resetPagination() {
        posts = []
        lastDocument = nil
    }
}
