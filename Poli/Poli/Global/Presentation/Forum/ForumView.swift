//
//  ForumView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI

struct ForumView: View {
    @StateObject private var viewModel = ForumViewModel()
    
    var body: some View {
        ZStack {
            Color(.blue)
                .ignoresSafeArea()
            
            NavigationView {
                List(viewModel.posts) { post in
                    NavigationLink(destination: DetailView(post: post)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.author["displayName"] ?? "Anonymous")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchPosts()
                }
                .navigationTitle("Forum")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink(destination: PostView()) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: MyPageView()) {
                            Image(systemName: "person.circle")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
}
