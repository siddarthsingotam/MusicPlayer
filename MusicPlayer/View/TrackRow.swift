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
            } else {
                ZStack {
                    Color.gray.opacity(0.3)
                        .frame(width: 50, height: 50)
                    Image(systemName: "music.note")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading) {
                Text(track.title ?? "Unknown Track")
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(track.artistName ?? "Unknown Artist")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(4)
    }
}
