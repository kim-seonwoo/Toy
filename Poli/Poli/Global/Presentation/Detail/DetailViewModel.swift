//
//  DetailViewModel.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/26/24.
//

import FirebaseFirestore
import SwiftUI

class DetailViewModel: ObservableObject {
    @Published var post: Post
    @Published var errorMessage: String = ""
    
    init(post: Post) {
        self.post = post
    }
}
