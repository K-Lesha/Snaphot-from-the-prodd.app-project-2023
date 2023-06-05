import Foundation
import AVKit

class VideoViewModel: ObservableObject {
    private let videoURL: URL?
    @Published var player: AVPlayer?
    
    init(url: String) {
        self.videoURL = URL(string: url)
    }
    
    func setPlayer(videoURL: URL) {
        player = AVPlayer(url: videoURL)
        player?.isMuted = false
        player?.play()
        beginVideoFromStart()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: nil) { (_) in
            self.player?.seek(to: CMTime.zero)
            self.player?.play()
        }
    }
    
    func turnOnThePlayer() {
        if player == nil,
        let videoURL {
            setPlayer(videoURL: videoURL)
        }
    }
    
    func turnOffThePlayer() {
        if player != nil {
            player?.isMuted = true
            player = nil
        }
    }
    
    private func beginVideoFromStart() {
        self.player?.seek(to: CMTime.zero)
    }
}
