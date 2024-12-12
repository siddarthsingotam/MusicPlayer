//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by Siddarth Singotam on 20.11.2024.
//

import SwiftUI

@main
struct MusicPlayerApp: App {
    @State private var audioPlayer = AudioPlayer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(audioPlayer)
                .modelContainer(for: MusicTrack.self)
        }
    }
}
