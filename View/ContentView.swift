//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Siddarth Singotam on 20.11.2024.
// fg

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @State private var selection: Tab = .nowPlaying
    
    var body: some View {
        TabView(selection: $selection) {
            NowPlaying()
                .tabItem({ Label("Now Playing", systemImage: "play.fill" ) })
                .tag(Tab.nowPlaying)
            Favorites()
                .tabItem({ Label("Favorites", systemImage: "star.fill" ) })
                .tag(Tab.favorites)
            Albums()
                .tabItem({ Label("Albums", systemImage: "play.square.stack" ) })
                .tag(Tab.albums)
            Tracks(tabSelection: $selection)
                .tabItem({ Label("Tracks", systemImage: "music.note.list" ) })
                .tag(Tab.tracks)
        }
        .onAppear {
            Task {
                await loadMusicFiles(context)
            }
        }
    }
}

enum Tab {
    case nowPlaying
    case favorites
    case albums
    case tracks
}

#Preview {
    ContentView()
}
