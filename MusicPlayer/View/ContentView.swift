//
//  ContentView.swift
//  MusicPlayer
//
//  Created by Siddarth Singotam on 20.11.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .favorites
    
    enum Tab {
        case favorites
        case albums
        case tracks
    }
    
    var body: some View {
        TabView(selection: $selection) {
            Favorites()
                .tabItem({ Label("Favorites", systemImage: "star.fill" ) })
                .tag(Tab.favorites)
            
            Albums()
                .tabItem({ Label("Albums", systemImage: "play.square.stack" ) })
                .tag(Tab.albums)
            Tracks()
                .tabItem({ Label("Tracks", systemImage: "music.note.list" ) })
                .tag(Tab.tracks)
        }
    }
}

#Preview {
    ContentView()
}
