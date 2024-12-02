//
//  Albums.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 20.11.2024.
//Hii

import SwiftUI
import SwiftData

struct Albums: View {
    @Query var tracks: [MusicTrack]
    @Binding var tabSelection: Tab
    private var albums: [[MusicTrack]] {
        let groupedTracks = Dictionary(grouping: tracks, by: { $0.albumName })
        return Array(groupedTracks.values)
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(albums, id: \.self) { album in
                        NavigationLink(destination: AlbumTracks(tabSelection: $tabSelection, album: album)) {
                            AlbumBox(album: album)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

//#Preview {
//    Albums()
//}
