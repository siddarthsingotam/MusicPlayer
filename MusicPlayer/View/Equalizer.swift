//
//  Equalizer.swift
//  MusicPlayer
//
//  Created by KHAI CAO on 2.12.2024.
//

import SwiftUI
import AVFoundation

struct Equalizer: View {
    var audioPlayer: AudioPlayer
    var freqs = ["32", "64", "125", "250", "500", "1k", "2k", "4k", "8k", "16k"]

    var body: some View {
        HStack {
            ForEach((0...9), id: \.self) { i in
                VStack {
                    Slider(value: Binding(get: { audioPlayer.eqGains[i] },
                                          set: { newValue in audioPlayer.setEQGain(forBand: i, value: newValue) }
                                          ),
                           in: -10...10, step: 1.0)
                        .colorScheme(.dark)
                        .frame(width: 200)
                        .padding(.horizontal, -85)
                        .fixedSize(horizontal: true, vertical: false)
                        .rotationEffect(.degrees(-90))
                    Text("\(freqs[i])")
                        .padding(.top, 90)
                        .font(.caption2)
                }
            }
        }
    }
}

//#Preview {
//    Equalizer()
//}
