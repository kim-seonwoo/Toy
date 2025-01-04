//
//  List.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/26/24.
//

import Foundation

struct Post: Identifiable {
    let id: String
    let title: String
    let content: String
    let author: [String: String]
    var conservative: Int
    var liberal: Int
    var likedBy: [String]
    let createdAt: String
}
