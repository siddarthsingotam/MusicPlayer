//
//  TrackRow.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 25.11.2024.
//

import SwiftUI

struct TrackRow: View {
    var track: MusicTrack
    
    var body: some View {
        HStack {
            Text("\(track.title!)")
            
            Spacer()
            
        }
        .padding(4)
    }
}
