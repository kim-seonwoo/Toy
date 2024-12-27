//
//  DetailView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/26/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @State private var newComment: String = ""
    
    init(post: Post) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(post: post))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Post Details
            VStack(alignment: .leading, spacing: 10) {
                Text("By \(viewModel.post.author["displayName"] ?? "Anonymous")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(viewModel.post.content)
                    .font(.body)
            }
            
            HStack {
                Button(action: {
                    viewModel.conservativePost()
                }) {
                    Label("\(viewModel.post.conservative)", systemImage: "hand.thumbsup")
                        .foregroundColor(.blue)
                }
                Button(action: {
                    viewModel.liberalPost()
                }) {
                    Label("\(viewModel.post.liberal)", systemImage: "hand.thumbsdown")
                        .foregroundColor(.red)
                }
            }
            
            Divider()
            
            // Add Comment Section
            VStack(alignment: .leading, spacing: 10) {
                TextField("Write a comment...", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    viewModel.addComment(content: newComment)
                    newComment = ""
                }) {
                    Text("Submit Comment")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .foregroundColor(.whiteBackground)
                        .background(.primary)
                        .cornerRadius(8)
                }
            }
            
            Divider()
            
            ScrollView {
                ForEach(viewModel.comments) { comment in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(comment.content)
                            .font(.body)
                        
                        Text("By \(comment.author["displayName"] ?? "Anonymous")")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Button(action: {
                                viewModel.updateCommentVote(for: "conservative", in: comment.id)
                            }) {
                                Label("\(comment.conservative)", systemImage: "hand.thumbsup")
                                    .foregroundColor(.blue)
                            }
                            Button(action: {
                                viewModel.updateCommentVote(for: "liberal", in: comment.id)
                            }) {
                                Label("\(comment.liberal)", systemImage: "hand.thumbsdown")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        }
        .padding()
        .navigationTitle(viewModel.post.title)
        .navigationBarTitleDisplayMode(.large)
    }
}
