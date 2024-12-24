//
//  ForumView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI

import SwiftUI

struct ForumView: View {
    @State private var showMyPageView = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(.whiteBackground)
                    .ignoresSafeArea()
                
                Text("Forum")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MyPageView(), isActive: $showMyPageView) {
                        Button(action: {
                            showMyPageView = true
                        }) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
    }
}
