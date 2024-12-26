//
//  PostView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/26/24.
//

import SwiftUI

struct PostView: View {
    @StateObject private var viewModel = PostViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TextField("제목을 입력하세요", text: $viewModel.title)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.tertiary, lineWidth: 1)
                            )
                            .cornerRadius(8)
                    
                    TextEditor(text: $viewModel.content)
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.tertiary, lineWidth: 1)
                        )
                    
                    Button(action: {
                        viewModel.createPost()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("작성완료")
                            .bold()
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .foregroundColor(.whiteBackground)
                            .background(.primary)
                            .cornerRadius(8)
                    }
                    
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .navigationTitle("게시글 작성")
            .tint(.primary)
        }
    }
}
