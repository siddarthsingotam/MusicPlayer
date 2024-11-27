//
//  Tracks.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 20.11.2024.
//

import SwiftUI
import SwiftData

struct Tracks: View {
    @Binding var tabSelection: Tab
    @Query(sort: \MusicTrack.title) var tracks: [MusicTrack]
    @State private var showFavoritesOnly = false
    
    var filteredTracks: [MusicTrack] {
        var temp = tracks
        
        temp = temp.filter { track in
            (!showFavoritesOnly || track.isFavorite)
        }
        
        return temp
    }

    
    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                
                ForEach(filteredTracks, id:\.self) { track in
//                    NavigationLink {
//                        EmptyView()
//                    } label: {
//                        TrackRow(track: track)
//                    }
//                    .onTapGesture {
//                        tracks.forEach { $0.isNowPlaying = false }
//                        track.isNowPlaying = true
//                        tabSelection = Tab.nowPlaying
//                    }
                    TrackRow(track: track)
                        .onTapGesture {
                            tracks.forEach { $0.isNowPlaying = false }
                            track.isNowPlaying = true
                            tabSelection = Tab.nowPlaying
                        }
                }
            }
            .animation(.default, value: filteredTracks)
            .navigationTitle("Tracks")
        }
        
    }
}
