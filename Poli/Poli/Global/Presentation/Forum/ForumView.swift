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
        NavigationView {
            List {
                ForEach(viewModel.posts.indices, id: \.self) { index in
                    let post = viewModel.posts[index]
                    NavigationLink(destination: DetailView(post: post)) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.author["displayName"] ?? "Anonymous")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onAppear {
                        if index == viewModel.posts.count - 1 {
                            viewModel.fetchNextPage()
                        }
                    }
                }
                
                if viewModel.isLoadingNextPage {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
            }
            .refreshable {
                viewModel.resetPagination()
                viewModel.fetchPosts()
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
