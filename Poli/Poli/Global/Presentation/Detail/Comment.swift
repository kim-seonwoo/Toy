//
//  Comment.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/26/24.
//

struct Comment: Identifiable {
    let id: String
    var content: String
    let postId: String 
    let author: [String: String]
    let createdAt: String
    var conservative: Int
    var liberal: Int
    var likedBy: [String]
}

