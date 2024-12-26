//
//  DetailView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/26/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    
    init(post: Post) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(post: post))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) { // 간격 설정
            Text("By \(viewModel.post.author["displayName"] ?? "Anonymous")")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(viewModel.post.content)
                .font(.body)
            
            Spacer() // 빈 공간을 아래에 배치
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationTitle(viewModel.post.title)
    }
}

