//
//  TrackRow.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 25.11.2024.
//

import SwiftUI

struct TrackRow: View {
    @State var track: MusicTrack
    @State private var errorMessage: String? = nil
    
    var body: some View {
        HStack {
            if let artworkData = track.artworkData, let uiImage = UIImage(data: artworkData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            if let trackTitle = track.title {
                Text(trackTitle)
            }
            
        }
        .padding(4)
    }
}
