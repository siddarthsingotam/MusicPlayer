//
//  NowPlaying.swift
//  MusicPlayer
//
//  Created by Siddarth Singotam on 25.11.2024.
//

import SwiftUI
import AVKit
import SwiftData

struct NowPlaying: View {
//    let audioFile = "something.mp3"
    @Environment(\.modelContext) private var context
    @Query(sort: \MusicTrack.title) var tracks: [MusicTrack]

    var audioFile: MusicTrack? { tracks.first(where: { $0.isNowPlaying == true }) }
    
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
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.5), radius: 8, x: 8, y: 8)
                    .shadow(color: colorScheme == .dark ? Color.black.opacity(0.3) : Color.white.opacity(0.5), radius: 10, x: -10, y: -10)
                    .padding(.top, 35)
                
                Text("\(audioFile?.title! ?? "Unknown Title")")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary) // Dynamic color
                    .padding(.top, 25)
                
                if let trackArtist = audioFile?.artistName {
                    Text(trackArtist)
                        .font(.caption)
                        .foregroundColor(.secondary) // Dynamic color
                        .padding(.top, 2)
                } else {
                    Text("Unknown Artist")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                VStack {
                    HStack {
                        Text(timeString(time: currentTime))
                        Spacer()
                        Button {
                            audioFile!.isFavorite.toggle()
                            
                            do {
                                try context.save()
                            }
                            catch {
                                print("Error \(error)")
                            }
                        } label: {
                            Label("Toggle favorite", systemImage: audioFile!.isFavorite ? "heart.fill" : "heart")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .font(.headline)
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
                    .padding(.bottom, 50) // added some padding for spacing between tab view and audio buttons Hstack
                }
            }
            .background(Color(UIColor.systemBackground)) // Adjusts based on system theme
            .onAppear {
                setupAudio()
            }
    }
    
    private func setupAudio() {
        guard let fileName = audioFile?.fileName else { return }
        let name = (fileName as NSString).deletingPathExtension
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        print(url)
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
