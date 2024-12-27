//
//  ContentView.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appStateManager = AppStateManager.shared

    var body: some View {
        Group {
            if appStateManager.isLoggedIn {
                ForumView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            appStateManager.checkAuthState()
        }
    }
}

