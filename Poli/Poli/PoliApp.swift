//
//  PoliApp.swift
//  Poli
//
//  Created by Seonwoo Kim on 12/23/24.
//

import SwiftUI

@main
struct PoliApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appStateManager = AppStateManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appStateManager)
        }
    }
}
