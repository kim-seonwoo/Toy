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
            
            VStack(alignment: .leading, spacing: 10) {
                Text("\(viewModel.post.author["displayName"] ?? "Anonymous")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(viewModel.post.content)
                    .font(.body)
            }
            
            HStack {
                Button(action: {
                    viewModel.conservativePost()
                }) {
                    Text("보수 \(viewModel.post.conservative)")
                        .foregroundColor(.conservative)
                }
                Button(action: {
                    viewModel.liberalPost()
                }) {
                    Text("진보 \(viewModel.post.liberal)")
                        .foregroundColor(.liberal)
                }
            }
            
            Divider()
            
            ScrollView {
                ForEach(viewModel.comments) { comment in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(comment.content)
                            .font(.body)
                        
                        HStack {
                            Circle()
                                .fill(comment.politicalOrientation.color)
                                .frame(width: 16, height: 16)
                            Text("\(comment.author["displayName"] ?? "Anonymous")")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Button(action: {
                                viewModel.updateCommentVote(for: "conservative", in: comment.id)
                            }) {
                                Text("보수 \(comment.conservative)")
                                    .foregroundColor(.conservative)
                            }
                            Button(action: {
                                viewModel.updateCommentVote(for: "liberal", in: comment.id)
                            }) {
                                Text("진보 \(comment.liberal)")
                                    .foregroundColor(.liberal)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Add Comment Section
            VStack(alignment: .leading, spacing: 10) {
                TextField("댓글", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    viewModel.addComment(content: newComment)
                    newComment = ""
                }) {
                    Text("댓글 작성")
                        .bold()
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .foregroundColor(.whiteBackground)
                        .background(.primary)
                        .cornerRadius(8)
                }
            }
            
            Divider()
            
        }
        .padding()
        .onAppear {
            viewModel.fetchComments()
        }
        .navigationTitle(viewModel.post.title)
        .navigationBarTitleDisplayMode(.large)
    }
    
}
