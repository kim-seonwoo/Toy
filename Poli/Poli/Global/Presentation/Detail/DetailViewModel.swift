//
//  DetailViewModel.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/26/24.
//

import FirebaseFirestore
import FirebaseAuth

class DetailViewModel: ObservableObject {
    @Published var post: Post
    @Published var comments: [Comment] = []
    @Published var errorMessage: String = ""
    
    private let db = Firestore.firestore()
    private let currentUserId = Auth.auth().currentUser?.uid ?? "unknown"
    
    init(post: Post) {
        self.post = post
    }
    
    func fetchComments() {
        let commentsRef = db.collection("comments").whereField("postId", isEqualTo: post.id).order(by: "createdAt", descending: false)
        
        commentsRef.getDocuments { snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch comments: \(error.localizedDescription)"
                }
            } else {
                DispatchQueue.main.async {
                    let fetchedComments = snapshot?.documents.compactMap { doc -> Comment? in
                        let data = doc.data()
                        return Comment(
                            id: doc.documentID,
                            content: data["content"] as? String ?? "",
                            postId: data["postId"] as? String ?? "",
                            author: data["author"] as? [String: String] ?? [:],
                            createdAt: data["createdAt"] as? String ?? "Unknown date",
                            conservative: data["conservative"] as? Int ?? 0,
                            liberal: data["liberal"] as? Int ?? 0,
                            likedBy: data["likedBy"] as? [String] ?? []
                        )
                    } ?? []
                    
                    self.comments = fetchedComments
                    
                    // Fetch political orientation for each author
                    for index in self.comments.indices {
                        let authorId = self.comments[index].author["uid"] ?? ""
                        self.fetchUserPoliticalOrientation(for: authorId) { orientation in
                            DispatchQueue.main.async {
                                self.comments[index].politicalOrientation = orientation
                            }
                        }
                    }
                }
            }
        }
    }

    private func fetchUserPoliticalOrientation(for userId: String, completion: @escaping (PoliticalOrientation) -> Void) {
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch user data: \(error.localizedDescription)")
                completion(.center) // 기본값 반환
            } else if let data = snapshot?.data() {
                let liberalCount = data["liberal"] as? Int ?? 0
                let conservativeCount = data["conservative"] as? Int ?? 0
                let percentages = UserPoliticalOrientationCalculator.calculatePercentage(
                    liberal: liberalCount,
                    conservative: conservativeCount
                )
                let orientation = UserPoliticalOrientationCalculator.determinePoliticalOrientation(
                    liberalPercentage: percentages.liberalPercentage
                )
                completion(orientation)
            }
        }
    }


    func addComment(content: String) {
        guard let user = Auth.auth().currentUser else {
            errorMessage = "You must be logged in to add a comment."
            AppStateManager.shared.logOut()
            return
        }
        
        let commentId = UUID().uuidString
        let commentRef = db.collection("comments").document(commentId)
        let createdAt = Date().formattedString()
        
        let commentData: [String: Any] = [
            "content": content,
            "postId": post.id,
            "author": [
                "uid": user.uid,
                "displayName": user.displayName ?? "Anonymous"
            ],
            "createdAt": createdAt,
            "conservative": 0,
            "liberal": 0,
            "likedBy": []
        ]
        
        commentRef.setData(commentData) { error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to add comment: \(error.localizedDescription)"
                }
            } else {
                DispatchQueue.main.async {
                    self.fetchComments()
                }
            }
        }
    }

    func updateCommentVote(for type: String, in commentId: String) {
        let commentRef = db.collection("comments").document(commentId)
        
        db.runTransaction { transaction, _ in
            let snapshot = try? transaction.getDocument(commentRef)
            guard let data = snapshot?.data() else { return nil }
            
            var count = data[type] as? Int ?? 0
            var likedBy = data["likedBy"] as? [String] ?? []
            
            // 중복 투표 방지
            guard !likedBy.contains(self.currentUserId) else { return nil }
            
            count += 1
            likedBy.append(self.currentUserId)
            
            // 업데이트된 데이터를 Firestore에 반영
            transaction.updateData([
                type: count,
                "likedBy": likedBy
            ], forDocument: commentRef)
            
            self.updateUserVoteCount(for: type)
            
            // 로컬 데이터 동기화
            DispatchQueue.main.async {
                if let index = self.comments.firstIndex(where: { $0.id == commentId }) {
                    if type == "conservative" {
                        self.comments[index].conservative = count
                    } else if type == "liberal" {
                        self.comments[index].liberal = count
                    }
                }
            }
            return nil
        } completion: { _, error in
            if let error = error {
                self.errorMessage = "Failed to update vote: \(error.localizedDescription)"
            } else {
                // 댓글 리스트 다시 가져오기
                self.fetchComments()
            }
        }
    }

    
    func updateUserVoteCount(for type: String) {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = "You must be logged in."
            AppStateManager.shared.logOut()
            return
        }

        let userRef = db.collection("users").document(user.uid)
        
        db.runTransaction { transaction, _ in
            let snapshot = try? transaction.getDocument(userRef)
            var data = snapshot?.data() ?? [:]
            
            var count = data[type] as? Int ?? 0
            count += 1
            
            transaction.updateData([type: count], forDocument: userRef)
            return nil
        } completion: { _, error in
            if let error = error {
                self.errorMessage = "Failed to update user vote count: \(error.localizedDescription)"
            }
        }
    }
    
    func updateVote(for type: String, in commentId: String? = nil) {
        let documentRef = commentId == nil
            ? db.collection("posts").document(post.id ?? "")
            : db.collection("comments").document(commentId ?? "")
        
        db.runTransaction { transaction, _ in
            let snapshot = try? transaction.getDocument(documentRef)
            guard let data = snapshot?.data() else { return nil }
            
            var count = data[type] as? Int ?? 0
            var likedBy = data["likedBy"] as? [String] ?? []
            
            guard !likedBy.contains(self.currentUserId) else { return nil }
            
            count += 1
            likedBy.append(self.currentUserId)
            
            transaction.updateData([
                type: count,
                "likedBy": likedBy
            ], forDocument: documentRef)
            
            if commentId == nil {
                DispatchQueue.main.async {
                    if type == "conservative" {
                        self.post.conservative = count
                    } else {
                        self.post.liberal = count
                    }
                }
            }
            
            self.updateUserVoteCount(for: type)
            return nil
        } completion: { _, error in
            if let error = error {
                self.errorMessage = "Failed to update vote: \(error.localizedDescription)"
            }
        }
    }
    
    func conservativePost() {
        updateVote(for: "conservative")
    }
    
    func liberalPost() {
        updateVote(for: "liberal")
    }
    
    func conservativeComment(commentId: String) {
        updateVote(for: "conservative", in: commentId)
    }
    
    func liberalComment(commentId: String) {
        updateVote(for: "liberal", in: commentId)
    }
}
