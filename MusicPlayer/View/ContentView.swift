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
    
    func loadMusicFiles() {
        // let fm = FileManager.default
        // let path  = Bundle.main.resourcePath!
        // var musicFiles: [Any] = []
        
        // do {
        //     let items = try fm.contentsOfDirectory(atPath: path)
            
        //     for item in items {
        //         if (item.hasSuffix("mp3")) {
        //             musicFiles.append(item)
        //         }
        //     }
            
        //     for musicFile in musicFiles {
        //         print(musicFile)
        //     }
            
        // }
        // catch {
        //     print("Error: \(error)")
        // }

        if let files = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) {
            files.forEach { print($0) }
        }
        else {
            print("No files found")
        }
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
        .onAppear {
            loadMusicFiles()
        }
    }
}

#Preview {
    ContentView()
}
