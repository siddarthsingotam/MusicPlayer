//
//  NowPlaying.swift
//  MusicPlayer
//
//  Created by Siddarth Singotam on 25.11.2024.
//

import SwiftUI
import AVKit

struct NowPlaying: View {
    let audioFile = "something.mp3"
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var player: AVAudioPlayer?
    @State private var isplaying = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    ModifiedButtonView(image: "arrow.left")
                    Spacer()
                    ModifiedButtonView(image: "slider.vertical.3")
                }
                Text("Now Playing")
                    .fontWeight(.bold)
                    .foregroundColor(.primary) // Dynamic color based on system theme
            }
            .padding(.all)
            
            Image("tree")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 55)
                .clipShape(Circle())
                .padding(.all, 8)
                .background(Color(UIColor.secondarySystemBackground)) // Adjusts for light/dark mode
                .clipShape(Circle())
                .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.5), radius: 8, x: 8, y: 8)
                .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.5), radius: 10, x: -10, y: -10)
                .padding(.top, 35)
            
            Text("Drift")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary) // Dynamic color
                .padding(.top, 25)
            
            Text("Robot Koch ft. nilu")
                .font(.caption)
                .foregroundColor(.secondary) // Dynamic color
                .padding(.top, 2)
            
            VStack {
                HStack {
                    Text(timeString(time: currentTime))
                    Spacer()
                    Text(timeString(time: totalTime))
                }
                .font(.caption)
                .foregroundColor(.primary) // Dynamic color
                .padding([.top, .leading, .trailing], 25)
                
                Slider(value: Binding(get: {currentTime},
                                      set: {newValue in audioTime(to: newValue)
                }), in: 0...totalTime)
                .padding([.top, .leading, .trailing], 20)
            }
            HStack {
                Button(action: {}, label: {
                    ModifiedButtonView(image: "backward.fill")
                    ModifiedButtonView(image: "play.fill")
                    ModifiedButtonView(image: "forward.fill")
                })
            }
        }
        .background(Color(UIColor.systemBackground)) // Adjusts based on system theme
        .onAppear {
            setupAudio()
        }
    }
    
    private func setupAudio() {
        guard let url = Bundle.main.url(forResource: audioFile, withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            totalTime = player?.duration ?? 0.0
        } catch {
            print("Error loading audio: \(error)")
        }
    }
    
    private func playAudio() {
        player?.play()
        isplaying = true
    }
    
    private func stopAudio() {
        player?.stop()
        isplaying = false
    }
    
    private func updateProgress() {
        guard let player = player else { return }
        currentTime = player.currentTime
    }
    
    private func audioTime(to time: TimeInterval){
        player?.currentTime = time
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time / 60)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60))
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    NowPlaying()
}
